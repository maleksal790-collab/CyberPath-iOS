#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

mkdir -p release
rm -f release/CyberPath-iOS-source.zip

zip -r release/CyberPath-iOS-source.zip \
  CyberPath \
  CyberPath.xcodeproj \
  docs \
  scripts \
  .github \
  README.md \
  IOS_HANDOFF.md \
  COMPLETION_STATUS.md \
  VERIFY_ON_MACOS.sh \
  Makefile \
  .gitignore \
  -x '*/xcuserdata/*' '*/DerivedData/*' '*/build/*' '*.xcresult' '*.ipa' '*.xcarchive/*'

echo "Release source package created at release/CyberPath-iOS-source.zip"

