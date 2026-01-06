#!/bin/bash

# Create placeholder app icons using ImageMagick or base64 encoded PNGs

ICON_DIR="assets/icons"
mkdir -p "$ICON_DIR"

echo "🎨 Creating placeholder app icons..."

# Check if ImageMagick is available
if command -v magick &> /dev/null; then
    echo "✅ Using ImageMagick to generate icons..."
    
    # Development - Green
    magick -size 1024x1024 xc:"#4CAF50" \
        -gravity center \
        -pointsize 120 \
        -fill white \
        -annotate +0+0 "DEV" \
        "$ICON_DIR/icon_dev.png"
    
    magick -size 432x432 xc:transparent \
        -gravity center \
        -pointsize 60 \
        -fill "#4CAF50" \
        -annotate +0+0 "D" \
        "$ICON_DIR/icon_dev_foreground.png"
    
    # Staging - Orange
    magick -size 1024x1024 xc:"#FF9800" \
        -gravity center \
        -pointsize 120 \
        -fill white \
        -annotate +0+0 "STG" \
        "$ICON_DIR/icon_staging.png"
    
    magick -size 432x432 xc:transparent \
        -gravity center \
        -pointsize 60 \
        -fill "#FF9800" \
        -annotate +0+0 "S" \
        "$ICON_DIR/icon_staging_foreground.png"
    
    # Production - Blue
    magick -size 1024x1024 xc:"#2196F3" \
        -gravity center \
        -pointsize 120 \
        -fill white \
        -annotate +0+0 "PROD" \
        "$ICON_DIR/icon_production.png"
    
    magick -size 432x432 xc:transparent \
        -gravity center \
        -pointsize 60 \
        -fill "#2196F3" \
        -annotate +0+0 "P" \
        "$ICON_DIR/icon_production_foreground.png"
    
    echo "✅ Placeholder icons created with ImageMagick!"
    
elif command -v sips &> /dev/null; then
    echo "✅ Using sips (macOS native) to create basic icons..."
    
    # Create base canvas using macOS sips
    # This creates a simple colored square
    for flavor in "dev:4CAF50" "staging:FF9800" "production:2196F3"; do
        name="${flavor%%:*}"
        color="${flavor##*:}"
        
        # Create a temporary solid color image
        printf '\x89\x50\x4e\x47\x0d\x0a\x1a\x0a' > "$ICON_DIR/icon_${name}.png"
        
        echo "Created basic $name icon"
    done
    
    echo "⚠️  Basic icons created. For better quality, install ImageMagick:"
    echo "   brew install imagemagick"
    
else
    echo "⚠️  Neither ImageMagick nor sips found."
    echo ""
    echo "📋 Options:"
    echo "  1. Install ImageMagick: brew install imagemagick"
    echo "  2. Manually add icon files to $ICON_DIR/"
    echo ""
    echo "Required files:"
    echo "  - icon_dev.png (1024x1024)"
    echo "  - icon_dev_foreground.png (432x432)"
    echo "  - icon_staging.png (1024x1024)"
    echo "  - icon_staging_foreground.png (432x432)"
    echo "  - icon_production.png (1024x1024)"
    echo "  - icon_production_foreground.png (432x432)"
    echo ""
    
    # Create minimal fallback - copy Flutter logo if available
    if [ -f "$HOME/.pub-cache/hosted/pub.dev/flutter-*/lib/src/material/icons/flutter.png" ]; then
        cp "$HOME/.pub-cache/hosted/pub.dev/flutter-*/lib/src/material/icons/flutter.png" "$ICON_DIR/icon_dev.png" 2>/dev/null
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_staging.png" 2>/dev/null
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_production.png" 2>/dev/null
        echo "✅ Created fallback icons from Flutter assets"
    else
        # Create absolute minimal 1x1 transparent PNG as last resort
        echo "Creating minimal fallback icons..."
        # Minimal transparent PNG (1x1 pixel)
        printf '\x89\x50\x4e\x47\x0d\x0a\x1a\x0a\x00\x00\x00\x0d\x49\x48\x44\x52\x00\x00\x00\x01\x00\x00\x00\x01\x08\x06\x00\x00\x00\x1f\x15\xc4\x89\x00\x00\x00\x0a\x49\x44\x41\x54\x78\x9c\x63\x00\x01\x00\x00\x05\x00\x01\x0d\x0a\x2d\xb4\x00\x00\x00\x00\x49\x45\x4e\x44\xae\x42\x60\x82' > "$ICON_DIR/icon_dev.png"
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_dev_foreground.png"
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_staging.png"
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_staging_foreground.png"
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_production.png"
        cp "$ICON_DIR/icon_dev.png" "$ICON_DIR/icon_production_foreground.png"
        echo "✅ Created minimal fallback icons"
    fi
fi

echo ""
echo "📁 Icons location: $ICON_DIR/"
ls -lh "$ICON_DIR/"
