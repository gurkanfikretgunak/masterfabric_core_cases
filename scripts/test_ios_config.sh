#!/bin/bash

# Test script for iOS flavor configuration
# This script checks if the iOS project is properly configured for flavors

set -e

PBXPROJ_PATH="ios/Runner.xcodeproj/project.pbxproj"
SCHEMES_PATH="ios/Runner.xcodeproj/xcshareddata/xcschemes"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Testing iOS Flavor Configuration${NC}"
echo "========================================"
echo ""

# Test counter
PASSED=0
TOTAL=0

# Function to run a test
run_test() {
    local test_name="$1"
    local test_command="$2"
    
    TOTAL=$((TOTAL + 1))
    echo -n "Testing: $test_name... "
    
    if eval "$test_command" > /dev/null 2>&1; then
        echo -e "${GREEN}✓ PASS${NC}"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        return 1
    fi
}

# Test 1: Check if pbxproj file exists
run_test "Xcode project file exists" "[ -f '$PBXPROJ_PATH' ]"

# Test 2: Check if schemes directory exists
run_test "Schemes directory exists" "[ -d '$SCHEMES_PATH' ]"

# Test 3: Check if development scheme exists
run_test "Development scheme exists" "[ -f '$SCHEMES_PATH/development.xcscheme' ]"

# Test 4: Check if staging scheme exists
run_test "Staging scheme exists" "[ -f '$SCHEMES_PATH/staging.xcscheme' ]"

# Test 5: Check if production scheme exists
run_test "Production scheme exists" "[ -f '$SCHEMES_PATH/production.xcscheme' ]"

# Test 6: Check if Runner scheme exists
run_test "Runner scheme exists" "[ -f '$SCHEMES_PATH/Runner.xcscheme' ]"

# Test 7: Validate development scheme XML
run_test "Development scheme is valid XML" "xmllint --noout '$SCHEMES_PATH/development.xcscheme' 2>&1"

# Test 8: Validate staging scheme XML
run_test "Staging scheme is valid XML" "xmllint --noout '$SCHEMES_PATH/staging.xcscheme' 2>&1"

# Test 9: Validate production scheme XML
run_test "Production scheme is valid XML" "xmllint --noout '$SCHEMES_PATH/production.xcscheme' 2>&1"

# Test 10: Check if build configurations exist in pbxproj
echo ""
echo -e "${BLUE}Checking Build Configurations...${NC}"
echo ""

check_config() {
    local config_name="$1"
    TOTAL=$((TOTAL + 1))
    echo -n "  $config_name... "
    
    if grep -q "$config_name" "$PBXPROJ_PATH" 2>/dev/null; then
        echo -e "${GREEN}✓ Found${NC}"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${YELLOW}⚠ Missing${NC}"
        return 1
    fi
}

# Check for standard configurations
check_config "Debug"
check_config "Release"
check_config "Profile"

# Check for flavor-specific configurations
FLAVOR_CONFIGS_EXIST=true

check_config "Debug-development" || FLAVOR_CONFIGS_EXIST=false
check_config "Debug-staging" || FLAVOR_CONFIGS_EXIST=false
check_config "Debug-production" || FLAVOR_CONFIGS_EXIST=false
check_config "Release-development" || FLAVOR_CONFIGS_EXIST=false
check_config "Release-staging" || FLAVOR_CONFIGS_EXIST=false
check_config "Release-production" || FLAVOR_CONFIGS_EXIST=false
check_config "Profile-development" || FLAVOR_CONFIGS_EXIST=false
check_config "Profile-staging" || FLAVOR_CONFIGS_EXIST=false
check_config "Profile-production" || FLAVOR_CONFIGS_EXIST=false

# Test 11: Check scheme content for proper BuildableReference
echo ""
echo -e "${BLUE}Checking Scheme Content...${NC}"
echo ""

check_scheme_content() {
    local scheme_file="$1"
    local scheme_name="$2"
    
    TOTAL=$((TOTAL + 1))
    echo -n "  $scheme_name has BuildableReference... "
    
    if grep -q "BuildableReference" "$scheme_file" 2>/dev/null; then
        echo -e "${GREEN}✓ Valid${NC}"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ Invalid${NC}"
        return 1
    fi
}

check_scheme_content "$SCHEMES_PATH/development.xcscheme" "development"
check_scheme_content "$SCHEMES_PATH/staging.xcscheme" "staging"
check_scheme_content "$SCHEMES_PATH/production.xcscheme" "production"

# Summary
echo ""
echo "========================================"
echo -e "${BLUE}Test Results${NC}"
echo "========================================"
echo -e "Total tests: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$((TOTAL - PASSED))${NC}"

if [ $PASSED -eq $TOTAL ]; then
    echo ""
    echo -e "${GREEN}✅ All tests passed!${NC}"
    echo ""
    exit 0
else
    echo ""
    if [ "$FLAVOR_CONFIGS_EXIST" = false ]; then
        echo -e "${YELLOW}⚠️  Some tests failed!${NC}"
        echo ""
        echo -e "${YELLOW}Missing flavor-specific build configurations.${NC}"
        echo "You need to configure them in Xcode:"
        echo ""
        echo "  1. Run: open ios/Runner.xcworkspace"
        echo "  2. Select Runner PROJECT (not target)"
        echo "  3. Under Info → Configurations"
        echo "  4. Duplicate Debug, Release, Profile for each flavor"
        echo ""
        echo "For detailed instructions, see README.md"
        echo ""
    else
        echo -e "${RED}❌ Some tests failed!${NC}"
        echo ""
    fi
    exit 1
fi
