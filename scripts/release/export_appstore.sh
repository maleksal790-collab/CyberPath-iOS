#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

archive_path="${CYBERPATH_ARCHIVE_PATH:-build/CyberPath.xcarchive}"
export_path="${CYBERPATH_EXPORT_PATH:-release/appstore}"

if [[ ! -d "$archive_path" ]]; then
  echo "Missing archive at $archive_path. Run scripts/release/archive_release.sh first." >&2
  exit 1
fi

mkdir -p "$export_path"

xcodebuild -exportArchive \
  -archivePath "$archive_path" \
  -exportPath "$export_path" \
  -exportOptionsPlist ExportOptions-AppStore.plist

echo "App Store export created at $export_path"

