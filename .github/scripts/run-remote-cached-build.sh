#!/usr/bin/env bash

set -euo pipefail

if [[ -z "${XCODECACHEPROG_TOKEN:-}" ]]; then
  echo "XCODECACHEPROG_TOKEN is required for remote cache builds" >&2
  exit 1
fi

CREDENTIAL_NAME="${XCODECACHEPROG_CREDENTIAL_NAME:-mastodon-ios}"
CONFIG_DIR="${RUNNER_TEMP}/xcodecacheprog"
CONFIG_FILE="${CONFIG_DIR}/XcodeRemoteCache.xcconfig"

mkdir -p "$CONFIG_DIR"

echo "Configuring Xcode remote compilation cache"
xcodecacheprog sync \
  --credential-name "$CREDENTIAL_NAME" \
  --credential-env XCODECACHEPROG_TOKEN

echo "Writing remote cache xcconfig: ${CONFIG_FILE}"
xcodecacheprog config > "$CONFIG_FILE"

echo "Removing all Xcode DerivedData before build"
rm -rf "${HOME}/Library/Developer/Xcode/DerivedData"

echo "Remote cache status before build"
xcodecacheprog status

echo "Running Mastodon build"
XCODE_XCCONFIG_FILE="$CONFIG_FILE" bundle exec fastlane ios build_only

echo
echo "Remote cache status after build"
xcodecacheprog status
