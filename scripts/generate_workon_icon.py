#!/usr/bin/env python3
"""
Generate WorkOn app icon with the distinctive red location marker.
Creates a 1024x1024 PNG suitable for flutter_launcher_icons.
"""

from PIL import Image, ImageDraw
import os

def create_workon_icon(size=1024, output_path='assets/images/workon_app_icon.png'):
    """
    Create WorkOn app icon with red location marker on light gray background.
    
    The icon features the distinctive red location pin that forms the 'O' in WorkOn.
    """
    # Colors from WorkOn branding
    background_color = '#E8E8E8'  # Light gray
    marker_color = '#E24A33'      # WorkOn red (from nomworkon.jpg)
    circle_color = '#FFFFFF'      # White inner circle
    
    # Create image with light gray background
    img = Image.new('RGBA', (size, size), background_color)
    draw = ImageDraw.Draw(img)
    
    # Calculate proportions for the location marker
    center_x = size // 2
    center_y = size // 2 - size // 20  # Slightly above center
    
    # Main marker dimensions
    marker_width = int(size * 0.55)
    marker_height = int(size * 0.70)
    
    # Draw the location marker shape (teardrop/pin shape)
    # Top circle part
    circle_radius = marker_width // 2
    circle_top = center_y - marker_height // 3
    
    # Draw the pin shape using polygon + ellipse
    # Bottom point of the pin
    point_y = center_y + marker_height // 2
    
    # Create the teardrop shape
    # Draw the circular top part
    top_circle_bbox = [
        center_x - circle_radius,
        circle_top,
        center_x + circle_radius,
        circle_top + circle_radius * 2
    ]
    
    # Draw filled ellipse for the top of the marker
    draw.ellipse(top_circle_bbox, fill=marker_color)
    
    # Draw the pointed bottom as a triangle
    triangle_top_y = circle_top + circle_radius
    triangle_points = [
        (center_x - circle_radius + 10, triangle_top_y),  # Left edge
        (center_x + circle_radius - 10, triangle_top_y),  # Right edge  
        (center_x, point_y)                                # Bottom point
    ]
    draw.polygon(triangle_points, fill=marker_color)
    
    # Draw inner white circle (the hole in the location pin)
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
    print(f"[OK] Created WorkOn icon: {output_path} ({size}x{size})")
    
    return output_path


def main():
    """Generate the WorkOn app icon."""
    # Change to project root if running from scripts folder
    script_dir = os.path.dirname(os.path.abspath(__file__))
    project_root = os.path.dirname(script_dir)
    os.chdir(project_root)
    
    create_workon_icon()
    print("\nNext steps:")
    print("1. Run: flutter pub get")
    print("2. Run: dart run flutter_launcher_icons")
    print("3. Verify icons in android/app/src/main/res/mipmap-* and ios/Runner/Assets.xcassets/")


if __name__ == '__main__':
    main()

