#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

archive_path="${CYBERPATH_ARCHIVE_PATH:-build/CyberPath.xcarchive}"

xcodebuild archive \
  -project CyberPath.xcodeproj \
  -scheme CyberPath \
  -archivePath "$archive_path" \
  CODE_SIGNING_ALLOWED="${CODE_SIGNING_ALLOWED:-NO}"

echo "Archive created at $archive_path"

