#!/usr/bin/env bash
set -euo pipefail

echo "🧹 Cleaning old build artifacts..."
rm -rf build/ release/ DerivedData/

echo "📁 Creating release directory..."
mkdir -p release

echo "📦 Zipping project..."
zip -r release/CyberPath-iOS-Clean.zip . \
  -x "*.git*" -x "*/xcuserdata/*" -x "*/DerivedData/*" -x "*build/*" -x "release/*"

echo "✅ Success!"
