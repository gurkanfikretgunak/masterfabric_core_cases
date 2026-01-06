.PHONY: help setup clean codegen icons build-dev build-stg build-prod run-dev run-stg run-prod build-all

# Colors for output
GREEN  := $(shell tput -Txterm setaf 2)
YELLOW := $(shell tput -Txterm setaf 3)
BLUE   := $(shell tput -Txterm setaf 4)
RESET  := $(shell tput -Txterm sgr0)

help: ## Show this help message
	@echo '${BLUE}MasterFabric Core Cases - Build System${RESET}'
	@echo '=========================================='
	@echo ''
	@echo 'Usage:'
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  ${YELLOW}%-15s${RESET} %s\n", $$1, $$2}' $(MAKEFILE_LIST)

setup: ## Initial project setup (run once)
	@echo "${BLUE}📦 Setting up project...${RESET}"
	@flutter pub get
	@mkdir -p scripts assets/icons
	@chmod +x scripts/*.sh 2>/dev/null || true
	@echo "${GREEN}✅ Setup complete!${RESET}"

clean: ## Clean build artifacts
	@echo "${BLUE}🧹 Cleaning build artifacts...${RESET}"
	@flutter clean
	@rm -rf build/
	@rm -rf .dart_tool/build/
	@echo "${GREEN}✅ Clean complete!${RESET}"

codegen: ## Run code generation (build_runner)
	@echo "${BLUE}⚙️  Running code generation...${RESET}"
	@flutter pub run build_runner build --delete-conflicting-outputs
	@echo "${GREEN}✅ Code generation complete!${RESET}"

icons: ## Generate app icons for all flavors
	@echo "${BLUE}🎨 Generating app icons...${RESET}"
	@if [ ! -f "assets/icons/icon_dev.png" ]; then \
		echo "${YELLOW}⚠️  Icon files not found. Creating placeholder icons...${RESET}"; \
		./scripts/create_placeholder_icons.sh; \
	fi
	@dart run flutter_launcher_icons
	@echo "${GREEN}✅ Icons generated!${RESET}"

# Full build flow following build.yaml
prebuild: clean setup codegen icons ## Complete pre-build process
	@echo "${GREEN}✅ Pre-build complete! Ready to build/run.${RESET}"

# Development flavor
run-dev: ## Run development flavor
	@echo "${GREEN}🟢 Running DEVELOPMENT flavor...${RESET}"
	@flutter run --flavor development -t lib/flavors/main_development.dart

build-dev: prebuild ## Build development APK
	@echo "${GREEN}📦 Building DEVELOPMENT APK...${RESET}"
	@flutter build apk --flavor development -t lib/flavors/main_development.dart
	@echo "${GREEN}✅ Development APK built!${RESET}"
	@echo "📁 Output: build/app/outputs/flutter-apk/app-development-release.apk"

# Staging flavor
run-stg: ## Run staging flavor
	@echo "${YELLOW}🟠 Running STAGING flavor...${RESET}"
	@flutter run --flavor staging -t lib/flavors/main_staging.dart

build-stg: prebuild ## Build staging APK
	@echo "${YELLOW}📦 Building STAGING APK...${RESET}"
	@flutter build apk --flavor staging -t lib/flavors/main_staging.dart
	@echo "${GREEN}✅ Staging APK built!${RESET}"
	@echo "📁 Output: build/app/outputs/flutter-apk/app-staging-release.apk"

# Production flavor
run-prod: ## Run production flavor
	@echo "${BLUE}🔵 Running PRODUCTION flavor...${RESET}"
	@flutter run --flavor production -t lib/flavors/main_production.dart

build-prod: prebuild ## Build production APK
	@echo "${BLUE}📦 Building PRODUCTION APK...${RESET}"
	@flutter build apk --flavor production -t lib/flavors/main_production.dart
	@echo "${GREEN}✅ Production APK built!${RESET}"
	@echo "📁 Output: build/app/outputs/flutter-apk/app-production-release.apk"

# Build all flavors
build-all: prebuild ## Build all flavors (dev, staging, production)
	@echo "${BLUE}📦 Building ALL flavors...${RESET}"
	@flutter build apk --flavor development -t lib/flavors/main_development.dart
	@flutter build apk --flavor staging -t lib/flavors/main_staging.dart
	@flutter build apk --flavor production -t lib/flavors/main_production.dart
	@echo "${GREEN}🎉 All builds complete!${RESET}"

# iOS builds (macOS only)
build-ios-dev: prebuild ## Build iOS development
	@echo "${BLUE}🍎 Building iOS DEVELOPMENT...${RESET}"
	@flutter build ios --flavor development -t lib/main_development.dart --no-codesign
	@echo "${GREEN}✅ iOS Development built!${RESET}"

build-ios-stg: prebuild ## Build iOS staging
	@echo "${BLUE}🍎 Building iOS STAGING...${RESET}"
	@flutter build ios --flavor staging -t lib/main_staging.dart --no-codesign
	@echo "${GREEN}✅ iOS Staging built!${RESET}"

build-ios-prod: prebuild ## Build iOS production
	@echo "${BLUE}🍎 Building iOS PRODUCTION...${RESET}"
	@flutter build ios --flavor production -t lib/main_production.dart --no-codesign
	@echo "${GREEN}✅ iOS Production built!${RESET}"

# Testing
test: ## Run all tests
	@echo "${BLUE}🧪 Running tests...${RESET}"
	@flutter test
	@echo "${GREEN}✅ Tests complete!${RESET}"

analyze: ## Run static analysis
	@echo "${BLUE}🔍 Running static analysis...${RESET}"
	@flutter analyze
	@echo "${GREEN}✅ Analysis complete!${RESET}"

format: ## Format code
	@echo "${BLUE}✨ Formatting code...${RESET}"
	@dart format lib/ test/
	@echo "${GREEN}✅ Formatting complete!${RESET}"

# Quick development commands
dev: codegen icons run-dev ## Quick dev: codegen + icons + run dev
stg: codegen icons run-stg ## Quick staging: codegen + icons + run staging
prod: codegen icons run-prod ## Quick production: codegen + icons + run production
