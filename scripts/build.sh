#!/bin/bash

# Build script following build.yaml flow
# This script is called by Makefile

set -e  # Exit on error

FLAVOR=${1:-all}
PLATFORM=${2:-android}

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 MasterFabric Core Cases Build System${NC}"
echo "============================================"
echo ""

# Step 1: Clean (following build.yaml)
clean_build() {
    echo -e "${BLUE}🧹 Step 1/5: Cleaning previous builds...${NC}"
    flutter clean
    rm -rf build/
    echo -e "${GREEN}✅ Clean complete${NC}"
    echo ""
}

# Step 2: Dependencies
install_deps() {
    echo -e "${BLUE}📦 Step 2/5: Installing dependencies...${NC}"
    flutter pub get
    echo -e "${GREEN}✅ Dependencies installed${NC}"
    echo ""
}

# Step 3: Code Generation (following build.yaml targets)
run_codegen() {
    echo -e "${BLUE}⚙️  Step 3/5: Running code generation...${NC}"
    echo "  - JSON Serialization"
    echo "  - Injectable DI"
    echo "  - Freezed Models"
    echo "  - Flutter Gen Assets"
    flutter pub run build_runner build --delete-conflicting-outputs
    echo -e "${GREEN}✅ Code generation complete${NC}"
    echo ""
}

# Step 4: Icon Generation (from build.yaml global options)
generate_icons() {
    echo -e "${BLUE}🎨 Step 4/5: Generating app icons...${NC}"
    flutter pub run flutter_launcher_icons
    echo -e "${GREEN}✅ Icons generated for all flavors${NC}"
    echo ""
}

# Step 5: Build
build_flavor() {
    local flavor=$1
    local target=$2
    
    echo -e "${BLUE}📱 Step 5/5: Building $flavor flavor for $PLATFORM...${NC}"
    echo "-----------------------------------"
    
    if [ "$PLATFORM" = "android" ] || [ "$PLATFORM" = "all" ]; then
        echo -e "${YELLOW}🤖 Building Android APK...${NC}"
        flutter build apk --flavor "$flavor" -t "$target" --release
        
        # Show output location
        APK_PATH="build/app/outputs/flutter-apk/app-${flavor}-release.apk"
        if [ -f "$APK_PATH" ]; then
            SIZE=$(du -h "$APK_PATH" | cut -f1)
            echo -e "${GREEN}✅ Android APK built successfully!${NC}"
            echo -e "📁 Location: $APK_PATH"
            echo -e "📊 Size: $SIZE"
        fi
    fi
    
    if [ "$PLATFORM" = "ios" ] || [ "$PLATFORM" = "all" ]; then
        if [[ "$OSTYPE" == "darwin"* ]]; then
            echo -e "${YELLOW}🍎 Building iOS...${NC}"
            flutter build ios --flavor "$flavor" -t "$target" --no-codesign --release
            echo -e "${GREEN}✅ iOS built successfully!${NC}"
        else
            echo -e "${YELLOW}⚠️  Skipping iOS build (not on macOS)${NC}"
        fi
    fi
    
    echo ""
}

# Execute build flow
main() {
    # Pre-build steps (following build.yaml flow)
    clean_build
    install_deps
    run_codegen
    generate_icons
    
    # Build step
    case $FLAVOR in
        dev|development)
            build_flavor "development" "lib/flavors/main_development.dart"
            ;;
        stg|staging)
            build_flavor "staging" "lib/flavors/main_staging.dart"
            ;;
        prod|production)
            build_flavor "production" "lib/flavors/main_production.dart"
            ;;
        all)
            echo -e "${BLUE}📦 Building all flavors...${NC}"
            echo ""
            build_flavor "development" "lib/main_development.dart"
            build_flavor "staging" "lib/main_staging.dart"
            build_flavor "production" "lib/main_production.dart"
            ;;
        *)
            echo -e "${RED}❌ Unknown flavor: $FLAVOR${NC}"
            echo "Usage: $0 [dev|stg|prod|all] [android|ios|all]"
            exit 1
            ;;
    esac
    
    echo -e "${GREEN}🎉 Build complete!${NC}"
    echo "============================================"
}

# Run main function
main
