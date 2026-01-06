# Testing Documentation

This document describes the testing infrastructure for the iOS flavor configuration scripts.

## Overview

The project includes comprehensive testing for iOS flavor configuration to ensure proper setup before attempting to build or run the application with flavors.

## Test Scripts

### 1. `test_ios_config.sh` - Integration Tests

**Purpose**: Validates the complete iOS flavor configuration

**What it tests**:
- ✓ Xcode project file exists
- ✓ Schemes directory exists  
- ✓ All flavor schemes exist (development, staging, production)
- ✓ Runner scheme exists
- ✓ All schemes are valid XML
- ✓ Standard build configurations (Debug, Release, Profile)
- ✓ Flavor-specific build configurations
  - Debug-development, Debug-staging, Debug-production
  - Release-development, Release-staging, Release-production
  - Profile-development, Profile-staging, Profile-production
- ✓ Scheme content has proper BuildableReference

**Usage**:
```bash
# Run directly
./scripts/test_ios_config.sh

# Or via Make
make ios-test
```

**Output**:
- Shows pass/fail status for each test
- Provides detailed instructions if tests fail
- Returns exit code 0 on success, 1 on failure

**Exit Codes**:
- `0`: All tests passed, iOS flavors properly configured
- `1`: Some tests failed, configuration needed

---

### 2. `test_scripts_unit.sh` - Unit Tests

**Purpose**: Validates the test scripts themselves

**What it tests**:
- ✓ Test scripts exist
- ✓ Scripts are executable
- ✓ Scripts have proper shebangs
- ✓ Required paths are defined
- ✓ All flavor schemes are checked
- ✓ XML validation is performed
- ✓ Build configurations are checked
- ✓ Scripts use colored output
- ✓ Exit codes are properly set
- ✓ Helpful instructions are provided

**Usage**:
```bash
# Run directly
./scripts/test_scripts_unit.sh

# Or via Make
make test-scripts
```

**Output**:
- Tests the internal structure of test scripts
- Validates script behavior and completeness
- Returns exit code 0 on success, 1 on failure

---

### 3. `configure_ios_flavors.sh` - Configuration Helper

**Purpose**: Guides users through iOS flavor setup

**What it does**:
- Runs `test_ios_config.sh` to check current state
- Provides success message if already configured
- Shows detailed instructions if configuration needed
- Links to README documentation

**Usage**:
```bash
# Run directly
./scripts/configure_ios_flavors.sh

# Or via Make
make ios-setup
```

---

## Testing Workflow

### For New Developers

1. **Initial Setup**:
   ```bash
   make setup
   ```

2. **Check iOS Configuration**:
   ```bash
   make ios-setup
   ```

3. **If Tests Fail**:
   - Follow the instructions printed by the script
   - Open Xcode: `open ios/Runner.xcworkspace`
   - Configure build configurations as instructed
   - Re-run: `make ios-test`

4. **If Tests Pass**:
   ```bash
   make run-dev  # or run-stg, run-prod
   ```

### For CI/CD

```bash
# In your CI pipeline
make test-scripts      # Validate test scripts
make ios-test         # Check iOS configuration
```

---

## Test Results Interpretation

### All Tests Pass (15/15 or 24/24)

```
✅ All tests passed!
```

**Meaning**: iOS flavors are properly configured. You can proceed with:
- `make run-dev`
- `make run-stg`
- `make run-prod`

### Some Tests Fail (Schemes only)

```
Testing: Development scheme exists... ✓ PASS
Testing: Staging scheme exists... ✓ PASS
...
Debug-development... ⚠ Missing
```

**Meaning**: Schemes exist (good) but build configurations are missing in Xcode project.

**Action Required**: Configure build configurations in Xcode (see instructions below)

### Critical Failures

```
Testing: Xcode project file exists... ✗ FAIL
```

**Meaning**: Project structure issue

**Action Required**: Check project integrity or repository state

---

## Manual Configuration Steps

If `make ios-test` shows missing build configurations:

1. **Open Xcode**:
   ```bash
   open ios/Runner.xcworkspace
   ```

2. **Select Runner PROJECT**:
   - Click "Runner" in the left navigator
   - Make sure the PROJECT (blue icon) is selected, not the target

3. **Navigate to Configurations**:
   - Click the "Info" tab
   - Expand the "Configurations" section

4. **Duplicate Configurations**:
   
   For Debug configurations:
   - Click "+" under Configurations
   - Select "Duplicate Debug Configuration"
   - Rename to: `Debug-development`
   - Repeat for: `Debug-staging`, `Debug-production`
   
   For Release configurations:
   - Duplicate Release Configuration three times
   - Name: `Release-development`, `Release-staging`, `Release-production`
   
   For Profile configurations:
   - Duplicate Profile Configuration three times
   - Name: `Profile-development`, `Profile-staging`, `Profile-production`

5. **Verify**:
   ```bash
   make ios-test
   ```

---

## Troubleshooting

### Issue: "xmllint: command not found"

**Solution**: xmllint is included with macOS. If missing:
```bash
# Update Xcode Command Line Tools
xcode-select --install
```

### Issue: Tests pass but `make run-prod` still fails

**Solution**: 
1. Clean build artifacts: `make clean`
2. Run setup again: `make setup`
3. Verify with: `make ios-test`
4. Try: `flutter run --flavor production -t lib/flavors/main_production.dart`

### Issue: "Duplicate configuration option disabled"

**Problem**: Target selected instead of project

**Solution**: 
- Click away from the target
- Select the Runner PROJECT (blue icon at top of navigator)
- Try again

---

## Alternative: Running Without Flavors

If you prefer not to configure Xcode, you can run without the `--flavor` flag:

```bash
flutter run -t lib/flavors/main_development.dart
flutter run -t lib/flavors/main_staging.dart
flutter run -t lib/flavors/main_production.dart
```

This works on iOS without requiring build configuration changes.

---

## Contributing

When modifying test scripts:

1. Run unit tests: `make test-scripts`
2. Run integration tests: `make ios-test`
3. Ensure both pass before committing
4. Update this documentation if behavior changes

---

## Test Coverage

| Component | Test Type | Coverage |
|-----------|-----------|----------|
| Scheme Files | Integration | ✓ Existence, XML validity |
| Build Configs | Integration | ✓ All 9 flavor configs |
| Project File | Integration | ✓ Existence, structure |
| Test Scripts | Unit | ✓ 15 validation checks |
| Helper Scripts | Unit | ✓ Integration with tests |

---

## Future Improvements

- [ ] Automated Xcode project modification
- [ ] Android flavor configuration tests
- [ ] Continuous integration examples
- [ ] Visual test result reporting
- [ ] Pre-commit hooks for validation
