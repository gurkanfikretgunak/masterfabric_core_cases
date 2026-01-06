#!/bin/bash

# Script to configure iOS flavors for the project
# This script checks the iOS configuration and provides guidance

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

echo "🔧 Configuring iOS flavors..."
echo ""

# Run the test script
if [ -f "$SCRIPT_DIR/test_ios_config.sh" ]; then
    "$SCRIPT_DIR/test_ios_config.sh"
    TEST_RESULT=$?
    
    if [ $TEST_RESULT -eq 0 ]; then
        echo ""
        echo "✅ iOS flavors are properly configured!"
        echo "   You can now run: make run-dev, make run-stg, or make run-prod"
        exit 0
    else
        # Test failed, instructions were already printed by the test script
        exit 1
    fi
else
    echo "❌ Error: test_ios_config.sh not found"
    exit 1
fi
