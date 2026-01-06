# App Icons Directory

Place your flavor-specific app icons in this directory.

## Required Icons:

### Development (Green Theme - #4CAF50)
- `icon_dev.png` - 1024x1024px main icon with green theme
- `icon_dev_foreground.png` - 432x432px foreground layer for adaptive icon

### Staging (Orange Theme - #FF9800)
- `icon_staging.png` - 1024x1024px main icon with orange theme
- `icon_staging_foreground.png` - 432x432px foreground layer for adaptive icon

### Production (Blue Theme - #2196F3)
- `icon_production.png` - 1024x1024px main icon with blue theme
- `icon_production_foreground.png` - 432x432px foreground layer for adaptive icon

## Generate Icons:

After placing your icon files, run:

```bash
make icons
# or
flutter pub run flutter_launcher_icons
```
