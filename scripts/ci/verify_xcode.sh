#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

destination="${CYBERPATH_IOS_DESTINATION:-platform=iOS Simulator,name=iPhone 15}"

xcodebuild -list -project CyberPath.xcodeproj
xcodebuild \
  -project CyberPath.xcodeproj \
  -scheme CyberPath \
  -destination "$destination" \
  -resultBundlePath build/CyberPath-Build.xcresult \
  build

echo "CyberPath iOS Xcode verification passed."

