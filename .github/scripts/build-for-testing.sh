#!/usr/bin/env bash

set -euo pipefail

FASTLANE_LANE="${FASTLANE_LANE:-build_tests}"
ENABLE_XCODE_COMPILATION_CACHE="${ENABLE_XCODE_COMPILATION_CACHE:-false}"

if [[ "${ENABLE_XCODE_COMPILATION_CACHE}" != "true" ]]; then
  echo "Running Mastodon ${FASTLANE_LANE} without compilation cache"
  exec bundle exec fastlane ios "$FASTLANE_LANE"
fi

case "${CACHE_MODE:-local}" in
  local)
    exec ./.github/scripts/run-cas-cached-build.sh
    ;;
  remote)
    exec ./.github/scripts/run-remote-cached-build.sh
    ;;
  *)
    echo "Unsupported CACHE_MODE: ${CACHE_MODE}" >&2
    exit 1
    ;;
esac
