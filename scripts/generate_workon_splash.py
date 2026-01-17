#!/usr/bin/env python3
"""
Generate WorkOn splash screen assets.
Creates splash images with the WorkOn location marker logo.
"""

from PIL import Image, ImageDraw
import os


def create_workon_splash(size=(1242, 2688), output_path='assets/images/workon_splash.png'):
    """
    Create WorkOn splash screen with red location marker on light gray background.
    
    Default size is iPhone 11 Pro Max (largest common size).
    The image will be centered and scaled appropriately by flutter_native_splash.
    """
    # Colors from WorkOn branding
    background_color = '#E8E8E8'  # Light gray (matches app icon)
    marker_color = '#E24A33'      # WorkOn red
    circle_color = '#FFFFFF'      # White inner circle
    
    width, height = size
    
    # Create image with light gray background
    img = Image.new('RGBA', (width, height), background_color)
    draw = ImageDraw.Draw(img)
    
    # Calculate proportions for the location marker (centered)
    center_x = width // 2
    center_y = height // 2 - height // 20  # Slightly above center
    
    # Marker size relative to screen (smaller than app icon for elegance)
    marker_scale = min(width, height) * 0.25
    
    # Main marker dimensions
    marker_width = int(marker_scale)
    marker_height = int(marker_scale * 1.27)  # Taller than wide
    
    # Draw the location marker shape
    circle_radius = marker_width // 2
    circle_top = center_y - marker_height // 3
    
    # Bottom point of the pin
    point_y = center_y + marker_height // 2
    
    # Draw the circular top part
    top_circle_bbox = [
        center_x - circle_radius,
        circle_top,
        center_x + circle_radius,
        circle_top + circle_radius * 2
    ]
    draw.ellipse(top_circle_bbox, fill=marker_color)
    
    # Draw the pointed bottom as a triangle
    triangle_top_y = circle_top + circle_radius
    triangle_points = [
        (center_x - circle_radius + 5, triangle_top_y),
        (center_x + circle_radius - 5, triangle_top_y),
        (center_x, point_y)
    ]
    draw.polygon(triangle_points, fill=marker_color)
    
    # Draw inner white circle
    inner_radius = int(circle_radius * 0.40)
    inner_center_y = circle_top + circle_radius
    inner_bbox = [
        center_x - inner_radius,
        inner_center_y - inner_radius,
        center_x + inner_radius,
        inner_center_y + inner_radius
    ]
    draw.ellipse(inner_bbox, fill=circle_color)
    
    # Ensure output directory exists
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    
    # Save the image
    img.save(output_path, 'PNG')
    print(f"[OK] Created WorkOn splash: {output_path} ({width}x{height})")
    
    return output_path


def create_splash_logo_only(size=512, output_path='assets/images/workon_splash_logo.png'):
    """
    Create just the WorkOn logo for splash (transparent background).
    This is used by flutter_native_splash with a separate background color.
    """
    # Colors from WorkOn branding
    marker_color = '#E24A33'      # WorkOn red
    circle_color = '#FFFFFF'      # White inner circle
    
    # Create image with transparent background
    img = Image.new('RGBA', (size, size), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    
    # Calculate proportions
    center_x = size // 2
    center_y = size // 2 - size // 20
    
    marker_width = int(size * 0.70)
    marker_height = int(size * 0.85)
    
    circle_radius = marker_width // 2
    circle_top = center_y - marker_height // 3
    point_y = center_y + marker_height // 2
    
    # Draw circular top
    top_circle_bbox = [
        center_x - circle_radius,
        circle_top,
        center_x + circle_radius,
        circle_top + circle_radius * 2
    ]
    draw.ellipse(top_circle_bbox, fill=marker_color)
    
    # Draw pointed bottom
    triangle_top_y = circle_top + circle_radius
    triangle_points = [
        (center_x - circle_radius + 8, triangle_top_y),
        (center_x + circle_radius - 8, triangle_top_y),
        (center_x, point_y)
    ]
    draw.polygon(triangle_points, fill=marker_color)
    
    # Draw inner white circle
    inner_radius = int(circle_radius * 0.40)
    inner_center_y = circle_top + circle_radius
    inner_bbox = [
        center_x - inner_radius,
        inner_center_y - inner_radius,
        center_x + inner_radius,
        inner_center_y + inner_radius
    ]
    draw.ellipse(inner_bbox, fill=circle_color)
    
    os.makedirs(os.path.dirname(output_path), exist_ok=True)
    img.save(output_path, 'PNG')
    print(f"[OK] Created WorkOn splash logo: {output_path} ({size}x{size})")
    
    return output_path


def main():
    """Generate WorkOn splash screen assets."""
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    os.chdir(project_root)
    
    # Create splash logo (for flutter_native_splash)
    create_splash_logo_only()
    
    # Create full splash image (backup/reference)
    create_workon_splash()
    
    print("\nNext steps:")
    print("1. Run: flutter pub get")
    print("2. Run: dart run flutter_native_splash:create")
    print("3. Test on device/emulator")


if __name__ == '__main__':
    main()

