#!/bin/bash

# Unit tests for configure_ios_flavors.sh script
# Tests the behavior and output of the iOS configuration script

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🧪 Unit Tests for iOS Configuration Scripts${NC}"
echo "================================================"
echo ""

# Test counter
PASSED=0
TOTAL=0

# Function to run a test
run_test() {
    local test_name="$1"
    local expected="$2"
    local actual="$3"
    
    TOTAL=$((TOTAL + 1))
    echo -n "Test $TOTAL: $test_name... "
    
    if [ "$expected" = "$actual" ]; then
        echo -e "${GREEN}✓ PASS${NC}"
        PASSED=$((PASSED + 1))
        return 0
    else
        echo -e "${RED}✗ FAIL${NC}"
        echo "  Expected: $expected"
        echo "  Actual: $actual"
        return 1
    fi
}

# Test 1: Check if test_ios_config.sh exists
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh exists... "
if [ -f "$SCRIPT_DIR/test_ios_config.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 2: Check if configure_ios_flavors.sh exists
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: configure_ios_flavors.sh exists... "
if [ -f "$SCRIPT_DIR/configure_ios_flavors.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 3: Check if test_ios_config.sh is executable
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh is executable... "
if [ -x "$SCRIPT_DIR/test_ios_config.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 4: Check if configure_ios_flavors.sh is executable
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: configure_ios_flavors.sh is executable... "
if [ -x "$SCRIPT_DIR/configure_ios_flavors.sh" ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 5: Test script has proper shebang
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh has bash shebang... "
first_line=$(head -n 1 "$SCRIPT_DIR/test_ios_config.sh")
if [[ "$first_line" == "#!/bin/bash"* ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 6: Configure script has proper shebang
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: configure_ios_flavors.sh has bash shebang... "
first_line=$(head -n 1 "$SCRIPT_DIR/configure_ios_flavors.sh")
if [[ "$first_line" == "#!/bin/bash"* ]]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 7: Test script defines required paths
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh defines PBXPROJ_PATH... "
if grep -q "PBXPROJ_PATH=" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 8: Test script defines schemes path
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh defines SCHEMES_PATH... "
if grep -q "SCHEMES_PATH=" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 9: Test script checks for all three flavor schemes
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh checks for all flavor schemes... "
has_dev=$(grep -c "development.xcscheme" "$SCRIPT_DIR/test_ios_config.sh" || true)
has_stg=$(grep -c "staging.xcscheme" "$SCRIPT_DIR/test_ios_config.sh" || true)
has_prod=$(grep -c "production.xcscheme" "$SCRIPT_DIR/test_ios_config.sh" || true)
if [ "$has_dev" -gt 0 ] && [ "$has_stg" -gt 0 ] && [ "$has_prod" -gt 0 ]; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 10: Test script validates XML
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh validates XML... "
if grep -q "xmllint" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 11: Test script checks build configurations
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh checks Debug-development config... "
if grep -q "Debug-development" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 12: Configure script calls test script
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: configure_ios_flavors.sh calls test_ios_config.sh... "
if grep -q "test_ios_config.sh" "$SCRIPT_DIR/configure_ios_flavors.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 13: Test output format (check if it uses colors)
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: Scripts use colored output... "
if grep -q "GREEN=" "$SCRIPT_DIR/test_ios_config.sh" && grep -q "RED=" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 14: Test exit codes are properly set
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh uses exit codes... "
if grep -q "exit 0" "$SCRIPT_DIR/test_ios_config.sh" && grep -q "exit 1" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Test 15: Test script provides helpful messages
TOTAL=$((TOTAL + 1))
echo -n "Test $TOTAL: test_ios_config.sh provides setup instructions... "
if grep -q "open ios/Runner.xcworkspace" "$SCRIPT_DIR/test_ios_config.sh"; then
    echo -e "${GREEN}✓ PASS${NC}"
    PASSED=$((PASSED + 1))
else
    echo -e "${RED}✗ FAIL${NC}"
fi

# Summary
echo ""
echo "================================================"
echo -e "${BLUE}Test Results${NC}"
echo "================================================"
echo -e "Total tests: $TOTAL"
echo -e "Passed: ${GREEN}$PASSED${NC}"
echo -e "Failed: ${RED}$((TOTAL - PASSED))${NC}"

if [ $PASSED -eq $TOTAL ]; then
    echo ""
    echo -e "${GREEN}✅ All unit tests passed!${NC}"
    echo ""
    exit 0
else
    echo ""
    echo -e "${RED}❌ Some unit tests failed!${NC}"
    echo ""
    exit 1
fi
