#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")"

echo "== CyberPath iOS: project schemes =="
xcodebuild -list -project CyberPath.xcodeproj

echo "== CyberPath iOS: simulator build =="
xcodebuild \
  -project CyberPath.xcodeproj \
  -scheme CyberPath \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build

echo "CyberPath iOS build completed."

