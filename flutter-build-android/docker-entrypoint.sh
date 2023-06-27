#!/bin/bash

echo "Copying files from /input to /app"
cp -r /input/* /app

echo "Building app on /app with BUILD_TYPE=\"$BUILD_TYPE\" and BUILD_PARAMS=\"$BUILD_PARAMS\""
echo "Running 'flutter pub get --enforce-lockfile'"
flutter pub get --enforce-lockfile

if [[ $ONLY_TESTS != true ]]; then
  flutter build $BUILD_TYPE $BUILD_PARAMS

  echo "Copying files from /app/build to /output"
  cp -r ./build/ /output/
fi


if [[ $RUN_TESTS == true || $ONLY_TESTS == true ]]; then
    flutter test
fi