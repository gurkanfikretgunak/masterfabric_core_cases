#!/bin/bash

# Run script for flavors

FLAVOR=${1:-development}

case $FLAVOR in
    dev|development)
        echo "🟢 Running DEVELOPMENT flavor..."
        flutter run --flavor development -t lib/flavors/main_development.dart
        ;;
    stg|staging)
        echo "🟠 Running STAGING flavor..."
        flutter run --flavor staging -t lib/flavors/main_staging.dart
        ;;
    prod|production)
        echo "🔵 Running PRODUCTION flavor..."
        flutter run --flavor production -t lib/flavors/main_production.dart
        ;;
    *)
        echo "❌ Unknown flavor: $FLAVOR"
        echo "Usage: ./scripts/run.sh [dev|staging|prod]"
        exit 1
        ;;
esac
