#!/usr/bin/zsh

echo "Running tests in root dir..."
flutter test --coverage --test-randomize-ordering-seed random
genhtml coverage/lcov.info -o coverage/

echo "\nRunning tests in price_tracker_api_client..."
cd packages/price_tracker_api_client
flutter test --coverage --test-randomize-ordering-seed random
genhtml coverage/lcov.info -o coverage/


echo "\nRunning tests in price_tracker_repository..."
cd ../price_tracker_repository
flutter test --coverage --test-randomize-ordering-seed random
genhtml coverage/lcov.info -o coverage/
