/// WorkOn App Icon Preview Widget
/// 
/// Use this to preview and export the app icon.
/// Run: flutter run -t lib/tools/app_icon_preview.dart
library;

import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '/config/workon_colors.dart';

void main() {
  runApp(const AppIconPreviewApp());
}

class AppIconPreviewApp extends StatelessWidget {
  const AppIconPreviewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WorkOn Icon Preview',
      theme: ThemeData.dark(),
      home: const AppIconPreviewPage(),
    );
  }
}

class AppIconPreviewPage extends StatelessWidget {
  const AppIconPreviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        title: const Text('WorkOn App Icon Preview'),
        backgroundColor: Colors.transparent,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Preview sizes
            const Text(
              '1024×1024 (App Store)',
              style: TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 16),
            
            // Large preview
            Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                boxShadow: [
                  BoxShadow(
                    color: WkColors.brandRed.withOpacity(0.3),
                    blurRadius: 40,
                    spreadRadius: 10,
                  ),
                ],
              ),
              child: const WorkOnAppIcon(size: 300),
            ),
            
            const SizedBox(height: 40),
            
            // Small previews row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SizePreview(label: '180px', size: 60),
                const SizedBox(width: 20),
                _SizePreview(label: '120px', size: 40),
                const SizedBox(width: 20),
                _SizePreview(label: '60px', size: 20),
                const SizedBox(width: 20),
                _SizePreview(label: '40px', size: 13),
              ],
            ),
            
            const SizedBox(height: 40),
            
            // Instructions
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 40),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                children: [
                  Text(
                    '📱 Export Instructions',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    '1. Open assets/icons/app_icon.svg in Figma\n'
                    '2. Export as PNG 1024×1024 (no transparency)\n'
                    '3. Run: dart run flutter_launcher_icons\n'
                    '4. Icons will be generated in ios/ and android/',
                    style: TextStyle(color: Colors.white60, height: 1.6),
                    textAlign: TextAlign.left,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SizePreview extends StatelessWidget {
  const _SizePreview({required this.label, required this.size});
  
  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        WorkOnAppIcon(size: size),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(color: Colors.white54, fontSize: 10)),
      ],
    );
  }
}

/// The actual WorkOn App Icon widget.
/// 
/// This can be exported at any size for the app stores.
class WorkOnAppIcon extends StatelessWidget {
  const WorkOnAppIcon({super.key, this.size = 1024});
  
  final double size;

  @override
  Widget build(BuildContext context) {
    final cornerRadius = size * 0.215; // iOS-like corner radius
    final iconSize = size * 0.45;
    final glowRadius = size * 0.25;
    
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1A1A1E),
            Color(0xFF0D0D0F),
          ],
        ),
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Glow effect
          Container(
            width: glowRadius * 2,
            height: glowRadius * 2,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: WkColors.brandRed.withOpacity(0.25),
                  blurRadius: glowRadius,
                  spreadRadius: glowRadius * 0.3,
                ),
              ],
            ),
          ),
          
          // Phone icon container
          Container(
            width: iconSize * 1.2,
            height: iconSize * 1.2,
            decoration: BoxDecoration(
              color: WkColors.brandRed.withOpacity(0.1),
              borderRadius: BorderRadius.circular(iconSize * 0.2),
            ),
          ),
          
          // Phone icon
          Icon(
            Icons.phone_in_talk_rounded,
            size: iconSize,
            color: WkColors.brandRed,
          ),
          
          // Location pin (brand signature)
          Positioned(
            right: size * 0.15,
            bottom: size * 0.15,
            child: Container(
              width: size * 0.08,
              height: size * 0.08,
              decoration: const BoxDecoration(
                color: WkColors.brandRed,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
