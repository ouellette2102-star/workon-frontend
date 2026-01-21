/// Deep link handling service for WorkOn.
///
/// Manages deep link routing, UTM parameter persistence, and attribution tracking.
///
/// **PR-21:** Deep links for mission/profile/invite + UTM support.
library;

import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Attribution data from deep links.
class Attribution {
  final String? utmSource;
  final String? utmMedium;
  final String? utmCampaign;
  final String? utmContent;
  final String? utmTerm;
  final String? referralCode;
  final DateTime timestamp;

  const Attribution({
    this.utmSource,
    this.utmMedium,
    this.utmCampaign,
    this.utmContent,
    this.utmTerm,
    this.referralCode,
    required this.timestamp,
  });

  factory Attribution.fromQueryParams(Map<String, String> params) {
    return Attribution(
      utmSource: params['utm_source'],
      utmMedium: params['utm_medium'],
      utmCampaign: params['utm_campaign'],
      utmContent: params['utm_content'],
      utmTerm: params['utm_term'],
      referralCode: params['ref'] ?? params['referral'],
      timestamp: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => {
        'utm_source': utmSource,
        'utm_medium': utmMedium,
        'utm_campaign': utmCampaign,
        'utm_content': utmContent,
        'utm_term': utmTerm,
        'ref': referralCode,
        'timestamp': timestamp.toIso8601String(),
      };

  factory Attribution.fromJson(Map<String, dynamic> json) {
    return Attribution(
      utmSource: json['utm_source'] as String?,
      utmMedium: json['utm_medium'] as String?,
      utmCampaign: json['utm_campaign'] as String?,
      utmContent: json['utm_content'] as String?,
      utmTerm: json['utm_term'] as String?,
      referralCode: json['ref'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.tryParse(json['timestamp'].toString()) ?? DateTime.now()
          : DateTime.now(),
    );
  }

  bool get hasData =>
      utmSource != null ||
      utmMedium != null ||
      utmCampaign != null ||
      referralCode != null;

  @override
  String toString() =>
      'Attribution(source: $utmSource, campaign: $utmCampaign, ref: $referralCode)';
}

/// Deep link types supported by WorkOn.
enum DeepLinkType {
  mission,
  profile,
  invite,
  unknown,
}

/// Parsed deep link data.
class DeepLinkData {
  final DeepLinkType type;
  final String? id;
  final Map<String, String> queryParams;
  final Attribution? attribution;

  const DeepLinkData({
    required this.type,
    this.id,
    this.queryParams = const {},
    this.attribution,
  });

  @override
  String toString() => 'DeepLinkData(type: $type, id: $id, params: $queryParams)';
}

/// Service for handling deep links and attribution tracking.
///
/// ## Supported Deep Link Formats
///
/// - `workon://mission/{missionId}` - Opens mission detail
/// - `workon://profile/{userId}` - Opens user profile
/// - `workon://invite?ref={code}&utm_source=...` - Invite link with attribution
///
/// ## Usage
///
/// ```dart
/// // Parse a deep link
/// final data = DeepLinkService.parseDeepLink(uri);
///
/// // Save attribution data
/// await DeepLinkService.saveAttribution(data.attribution);
///
/// // Get saved attribution
/// final attr = await DeepLinkService.getAttribution();
/// ```
abstract final class DeepLinkService {
  // ─────────────────────────────────────────────────────────────────────────
  // Storage Keys
  // ─────────────────────────────────────────────────────────────────────────

  static const String _keyUtmSource = 'deep_link_utm_source';
  static const String _keyUtmMedium = 'deep_link_utm_medium';
  static const String _keyUtmCampaign = 'deep_link_utm_campaign';
  static const String _keyUtmContent = 'deep_link_utm_content';
  static const String _keyUtmTerm = 'deep_link_utm_term';
  static const String _keyReferralCode = 'deep_link_referral_code';
  static const String _keyTimestamp = 'deep_link_timestamp';

  // ─────────────────────────────────────────────────────────────────────────
  // Parsing
  // ─────────────────────────────────────────────────────────────────────────

  /// Parses a deep link URI into [DeepLinkData].
  ///
  /// Supported formats:
  /// - `workon://mission/{missionId}`
  /// - `workon://profile/{userId}`
  /// - `workon://invite?ref={code}&utm_source=...`
  /// - `https://workon.app/mission/{missionId}`
  /// - `https://workon.app/profile/{userId}`
  static DeepLinkData parseDeepLink(Uri uri) {
    debugPrint('[DeepLinkService] Parsing URI: $uri');

    final pathSegments = uri.pathSegments;
    final queryParams = uri.queryParameters;

    // Extract attribution from query params
    Attribution? attribution;
    if (queryParams.isNotEmpty) {
      attribution = Attribution.fromQueryParams(queryParams);
      if (attribution.hasData) {
        debugPrint('[DeepLinkService] Found attribution: $attribution');
      }
    }

    // Parse path to determine type
    if (pathSegments.isEmpty) {
      // Check host for type (workon://mission/xxx vs workon://invite)
      final host = uri.host.toLowerCase();
      return _parseByHost(host, queryParams, attribution);
    }

    final firstSegment = pathSegments.first.toLowerCase();
    final id = pathSegments.length > 1 ? pathSegments[1] : null;

    switch (firstSegment) {
      case 'mission':
      case 'missions':
        return DeepLinkData(
          type: id != null ? DeepLinkType.mission : DeepLinkType.unknown,
          id: id,
          queryParams: queryParams,
          attribution: attribution,
        );

      case 'profile':
      case 'user':
      case 'profiles':
        return DeepLinkData(
          type: id != null ? DeepLinkType.profile : DeepLinkType.unknown,
          id: id,
          queryParams: queryParams,
          attribution: attribution,
        );

      case 'invite':
      case 'referral':
      case 'join':
        return DeepLinkData(
          type: DeepLinkType.invite,
          id: queryParams['ref'] ?? queryParams['referral'],
          queryParams: queryParams,
          attribution: attribution,
        );

      default:
        debugPrint('[DeepLinkService] Unknown path segment: $firstSegment');
        return DeepLinkData(
          type: DeepLinkType.unknown,
          queryParams: queryParams,
          attribution: attribution,
        );
    }
  }

  /// Parses by host when path is empty (e.g., workon://invite?ref=xxx).
  static DeepLinkData _parseByHost(
    String host,
    Map<String, String> queryParams,
    Attribution? attribution,
  ) {
    switch (host) {
      case 'mission':
      case 'missions':
        final id = queryParams['id'] ?? queryParams['missionId'];
        return DeepLinkData(
          type: id != null ? DeepLinkType.mission : DeepLinkType.unknown,
          id: id,
          queryParams: queryParams,
          attribution: attribution,
        );

      case 'profile':
      case 'user':
        final id = queryParams['id'] ?? queryParams['userId'];
        return DeepLinkData(
          type: id != null ? DeepLinkType.profile : DeepLinkType.unknown,
          id: id,
          queryParams: queryParams,
          attribution: attribution,
        );

      case 'invite':
      case 'referral':
      case 'join':
        return DeepLinkData(
          type: DeepLinkType.invite,
          id: queryParams['ref'] ?? queryParams['referral'],
          queryParams: queryParams,
          attribution: attribution,
        );

      default:
        return DeepLinkData(
          type: DeepLinkType.unknown,
          queryParams: queryParams,
          attribution: attribution,
        );
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Attribution Persistence
  // ─────────────────────────────────────────────────────────────────────────

  /// Saves attribution data to local storage.
  ///
  /// Only saves if there's actual attribution data.
  static Future<void> saveAttribution(Attribution? attribution) async {
    if (attribution == null || !attribution.hasData) {
      debugPrint('[DeepLinkService] No attribution data to save');
      return;
    }

    debugPrint('[DeepLinkService] Saving attribution: $attribution');

    try {
      final prefs = await SharedPreferences.getInstance();

      if (attribution.utmSource != null) {
        await prefs.setString(_keyUtmSource, attribution.utmSource!);
      }
      if (attribution.utmMedium != null) {
        await prefs.setString(_keyUtmMedium, attribution.utmMedium!);
      }
      if (attribution.utmCampaign != null) {
        await prefs.setString(_keyUtmCampaign, attribution.utmCampaign!);
      }
      if (attribution.utmContent != null) {
        await prefs.setString(_keyUtmContent, attribution.utmContent!);
      }
      if (attribution.utmTerm != null) {
        await prefs.setString(_keyUtmTerm, attribution.utmTerm!);
      }
      if (attribution.referralCode != null) {
        await prefs.setString(_keyReferralCode, attribution.referralCode!);
      }
      await prefs.setString(_keyTimestamp, attribution.timestamp.toIso8601String());

      debugPrint('[DeepLinkService] Attribution saved successfully');
    } catch (e) {
      debugPrint('[DeepLinkService] Failed to save attribution: $e');
    }
  }

  /// Retrieves saved attribution data.
  static Future<Attribution?> getAttribution() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final timestamp = prefs.getString(_keyTimestamp);
      if (timestamp == null) return null;

      return Attribution(
        utmSource: prefs.getString(_keyUtmSource),
        utmMedium: prefs.getString(_keyUtmMedium),
        utmCampaign: prefs.getString(_keyUtmCampaign),
        utmContent: prefs.getString(_keyUtmContent),
        utmTerm: prefs.getString(_keyUtmTerm),
        referralCode: prefs.getString(_keyReferralCode),
        timestamp: DateTime.tryParse(timestamp) ?? DateTime.now(),
      );
    } catch (e) {
      debugPrint('[DeepLinkService] Failed to get attribution: $e');
      return null;
    }
  }

  /// Clears saved attribution data.
  static Future<void> clearAttribution() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_keyUtmSource);
      await prefs.remove(_keyUtmMedium);
      await prefs.remove(_keyUtmCampaign);
      await prefs.remove(_keyUtmContent);
      await prefs.remove(_keyUtmTerm);
      await prefs.remove(_keyReferralCode);
      await prefs.remove(_keyTimestamp);
      debugPrint('[DeepLinkService] Attribution cleared');
    } catch (e) {
      debugPrint('[DeepLinkService] Failed to clear attribution: $e');
    }
  }

  // ─────────────────────────────────────────────────────────────────────────
  // Link Generation
  // ─────────────────────────────────────────────────────────────────────────

  /// Generates a mission share link.
  static String generateMissionLink(String missionId) {
    return 'https://workon.app/mission/$missionId';
  }

  /// Generates a profile share link.
  static String generateProfileLink(String userId) {
    return 'https://workon.app/profile/$userId';
  }

  /// Generates an invite link with optional referral code.
  static String generateInviteLink({
    String? referralCode,
    String? utmSource,
    String? utmCampaign,
  }) {
    final params = <String, String>{};
    if (referralCode != null) params['ref'] = referralCode;
    if (utmSource != null) params['utm_source'] = utmSource;
    if (utmCampaign != null) params['utm_campaign'] = utmCampaign;

    final queryString =
        params.entries.map((e) => '${e.key}=${e.value}').join('&');

    return queryString.isEmpty
        ? 'https://workon.app/invite'
        : 'https://workon.app/invite?$queryString';
  }
}

