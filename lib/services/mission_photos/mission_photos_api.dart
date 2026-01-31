/// Mission Photos API client for WorkOn.
///
/// Handles photo upload and retrieval for missions.
///
/// **FL-PHOTOS:** Initial implementation.
library;

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

import '../api/api_client.dart';
import '../auth/auth_errors.dart';
import '../auth/token_storage.dart';

/// Exception thrown by [MissionPhotosApi].
class MissionPhotosException implements Exception {
  final String message;
  final int? statusCode;

  const MissionPhotosException(this.message, [this.statusCode]);

  @override
  String toString() => 'MissionPhotosException: $message';
}

/// A photo attached to a mission.
class MissionPhoto {
  const MissionPhoto({
    required this.id,
    required this.missionId,
    required this.userId,
    required this.url,
    required this.createdAt,
    this.thumbnailUrl,
    this.fileName,
  });

  factory MissionPhoto.fromJson(Map<String, dynamic> json) {
    return MissionPhoto(
      id: json['id']?.toString() ?? '',
      missionId: json['missionId']?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      url: json['url'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString()) ?? DateTime.now()
          : DateTime.now(),
      thumbnailUrl: json['thumbnailUrl'] as String?,
      fileName: json['fileName'] as String?,
    );
  }

  final String id;
  final String missionId;
  final String userId;
  final String url;
  final DateTime createdAt;
  final String? thumbnailUrl;
  final String? fileName;

  Map<String, dynamic> toJson() => {
        'id': id,
        'missionId': missionId,
        'userId': userId,
        'url': url,
        'createdAt': createdAt.toIso8601String(),
        'thumbnailUrl': thumbnailUrl,
        'fileName': fileName,
      };
}

/// Response from photo upload.
class UploadPhotosResponse {
  const UploadPhotosResponse({
    required this.uploaded,
    required this.photos,
  });

  factory UploadPhotosResponse.fromJson(Map<String, dynamic> json) {
    return UploadPhotosResponse(
      uploaded: json['uploaded'] as int? ?? 0,
      photos: (json['photos'] as List<dynamic>?)
              ?.map((e) => MissionPhoto.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  final int uploaded;
  final List<MissionPhoto> photos;
}

/// API client for mission photos operations.
class MissionPhotosApi {
  const MissionPhotosApi();

  /// Gets all photos for a mission.
  ///
  /// Calls `GET /api/v1/missions/:missionId/photos`.
  Future<List<MissionPhoto>> getPhotos(String missionId) async {
    debugPrint('[MissionPhotosApi] Getting photos for mission: $missionId');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/missions/$missionId/photos');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MissionPhotosApi] GET $uri');
      final response = await ApiClient.client
          .get(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MissionPhotosApi] getPhotos: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 404) {
        return [];
      }

      if (response.statusCode != 200) {
        throw MissionPhotosException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body);
      final List<dynamic> data;
      if (json is List) {
        data = json;
      } else if (json is Map<String, dynamic>) {
        data = json['photos'] ?? json['data'] ?? [];
      } else {
        data = [];
      }

      return data
          .map((e) => MissionPhoto.fromJson(e as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw const MissionPhotosException('Connexion impossible');
    } on http.ClientException {
      throw const MissionPhotosException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionPhotosException || e is AuthException) rethrow;
      debugPrint('[MissionPhotosApi] getPhotos error: $e');
      throw const MissionPhotosException('Une erreur est survenue');
    }
  }

  /// Uploads photos to a mission.
  ///
  /// Calls `POST /api/v1/missions/:missionId/photos` with multipart/form-data.
  Future<UploadPhotosResponse> uploadPhotos(
    String missionId,
    List<File> files,
  ) async {
    debugPrint('[MissionPhotosApi] Uploading ${files.length} photos to mission: $missionId');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/missions/$missionId/photos');

    try {
      final request = http.MultipartRequest('POST', uri);
      request.headers['Authorization'] = 'Bearer $token';

      for (final file in files) {
        final filename = file.path.split('/').last;
        final extension = filename.split('.').last.toLowerCase();
        String mimeType;
        switch (extension) {
          case 'jpg':
          case 'jpeg':
            mimeType = 'image/jpeg';
          case 'png':
            mimeType = 'image/png';
          case 'webp':
            mimeType = 'image/webp';
          default:
            mimeType = 'image/jpeg';
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            'files',
            file.path,
            contentType: MediaType.parse(mimeType),
          ),
        );
      }

      debugPrint('[MissionPhotosApi] POST $uri (multipart)');
      final streamedResponse = await request.send().timeout(
            const Duration(seconds: 60), // Longer timeout for uploads
          );
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('[MissionPhotosApi] uploadPhotos: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 400) {
        final json = jsonDecode(response.body) as Map<String, dynamic>;
        throw MissionPhotosException(
          json['message'] as String? ?? 'Fichier invalide',
          400,
        );
      }

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw MissionPhotosException('Erreur ${response.statusCode}');
      }

      final json = jsonDecode(response.body) as Map<String, dynamic>;
      return UploadPhotosResponse.fromJson(json);
    } on TimeoutException {
      throw const MissionPhotosException('Upload timeout - fichiers trop volumineux?');
    } on http.ClientException {
      throw const MissionPhotosException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionPhotosException || e is AuthException) rethrow;
      debugPrint('[MissionPhotosApi] uploadPhotos error: $e');
      throw const MissionPhotosException('Une erreur est survenue');
    }
  }

  /// Deletes a photo from a mission.
  ///
  /// Calls `DELETE /api/v1/missions/:missionId/photos/:photoId`.
  Future<void> deletePhoto(String missionId, String photoId) async {
    debugPrint('[MissionPhotosApi] Deleting photo: $photoId from mission: $missionId');

    // FIX-TOKEN-SYNC: Use TokenStorage directly
    final token = TokenStorage.getToken();
    if (token == null || token.isEmpty) {
      throw const UnauthorizedException();
    }

    final uri = ApiClient.buildUri('/missions/$missionId/photos/$photoId');
    final headers = {
      ...ApiClient.defaultHeaders,
      'Authorization': 'Bearer $token',
    };

    try {
      debugPrint('[MissionPhotosApi] DELETE $uri');
      final response = await ApiClient.client
          .delete(uri, headers: headers)
          .timeout(ApiClient.connectionTimeout);

      debugPrint('[MissionPhotosApi] deletePhoto: ${response.statusCode}');

      if (response.statusCode == 401 || response.statusCode == 403) {
        throw const UnauthorizedException();
      }

      if (response.statusCode == 404) {
        throw const MissionPhotosException('Photo introuvable', 404);
      }

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw MissionPhotosException('Erreur ${response.statusCode}');
      }
    } on TimeoutException {
      throw const MissionPhotosException('Connexion impossible');
    } on http.ClientException {
      throw const MissionPhotosException('Erreur réseau');
    } on Exception catch (e) {
      if (e is MissionPhotosException || e is AuthException) rethrow;
      debugPrint('[MissionPhotosApi] deletePhoto error: $e');
      throw const MissionPhotosException('Une erreur est survenue');
    }
  }
}
