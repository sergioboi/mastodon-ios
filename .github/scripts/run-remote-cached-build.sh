#!/usr/bin/env bash

set -euo pipefail

CONFIG_DIR="${RUNNER_TEMP}/xcodecacheprog"
CONFIG_FILE="${CONFIG_DIR}/XcodeRemoteCache.xcconfig"
FASTLANE_LANE="${FASTLANE_LANE:-build_only}"

mkdir -p "$CONFIG_DIR"

echo "Writing remote cache xcconfig: ${CONFIG_FILE}"
xcodecacheprog config > "$CONFIG_FILE"

echo "Removing all Xcode DerivedData before build"
rm -rf "${HOME}/Library/Developer/Xcode/DerivedData"

echo "Remote cache status before build"
xcodecacheprog status

echo "Running Mastodon ${FASTLANE_LANE}"
XCODE_XCCONFIG_FILE="$CONFIG_FILE" bundle exec fastlane ios "$FASTLANE_LANE"

echo
echo "Remote cache status after build"
xcodecacheprog status
