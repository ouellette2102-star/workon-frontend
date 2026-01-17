#!/usr/bin/env python3
"""
Generate splash screen background images with correct WorkOn colors.
"""

from PIL import Image
import os


def create_background(color, output_path, size=(1, 1)):
    """Create a solid color background image."""
    img = Image.new('RGB', size, color)
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, 'PNG')
    print(f"[OK] Created: {output_path}")


def main():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    os.chdir(project_root)
    
    light_color = '#E8E8E8'  # Light gray
    dark_color = '#1A1A1A'   # Dark gray
    
    # Android backgrounds
    android_paths = [
        'android/app/src/main/res/drawable/background.png',
        'android/app/src/main/res/drawable-v21/background.png',
        'android/app/src/main/res/drawable-night/background.png',
        'android/app/src/main/res/drawable-night-v21/background.png',
    ]
    
    for path in android_paths:
        if 'night' in path:
            create_background(dark_color, path)
        else:
            create_background(light_color, path)
    
    # iOS backgrounds
    ios_light = 'ios/Runner/Assets.xcassets/LaunchBackground.imageset/background.png'
    ios_dark = 'ios/Runner/Assets.xcassets/LaunchBackground.imageset/darkbackground.png'
    
    create_background(light_color, ios_light)
    create_background(dark_color, ios_dark)
    
    print("\n[OK] All splash backgrounds updated to WorkOn colors!")


if __name__ == '__main__':
    main()

