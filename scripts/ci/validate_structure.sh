#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/../.."

required_files=(
  "CyberPath.xcodeproj/project.pbxproj"
  "CyberPath.xcodeproj/xcshareddata/xcschemes/CyberPath.xcscheme"
  "CyberPath/CyberPathApp.swift"
  "CyberPath/ContentView.swift"
  "CyberPath/Models.swift"
  "CyberPath/CyberPathData.swift"
  "CyberPath/ProgressStore.swift"
  "CyberPath/Assets.xcassets/Contents.json"
  "CyberPath/Assets.xcassets/AppIcon.appiconset/Contents.json"
  "CyberPath/Assets.xcassets/AccentColor.colorset/Contents.json"
  "docs/governance/DELIVERY_PIPELINE.md"
  "docs/governance/QUALITY_GATES.md"
  "docs/governance/TEST_STRATEGY.md"
  "docs/governance/SECURITY_PRIVACY.md"
  "docs/governance/TRACEABILITY_MATRIX.md"
  "docs/governance/RELEASE_PROCESS.md"
  "docs/governance/RISK_REGISTER.md"
  "docs/governance/ACCEPTANCE_CHECKLIST.md"
  "docs/governance/APP_STORE_CONNECT_DEPLOYMENT.md"
  "docs/governance/PRIVACY_NUTRITION.md"
  "docs/governance/RELEASE_NOTES.md"
  ".github/workflows/ios-governed-delivery.yml"
  ".github/CODEOWNERS"
  ".github/pull_request_template"
  "ExportOptions-AppStore.plist"
)

for file in "${required_files[@]}"; do
  if [[ ! -f "$file" ]]; then
    echo "Missing required file: $file" >&2
    exit 1
  fi
done

icon_count=$(find CyberPath/Assets.xcassets/AppIcon.appiconset -name '*.png' | wc -l | tr -d ' ')
if [[ "$icon_count" != "10" ]]; then
  echo "Expected 10 app icon PNG files, found $icon_count" >&2
  exit 1
fi

if rg --hidden --line-number --with-filename --glob '!scripts/ci/validate_structure.sh' --glob '!scripts/ci/validate_structure.ps1' 'TODO|FIXME' CyberPath scripts docs .github README.md IOS_HANDOFF.md COMPLETION_STATUS.md; then
  echo "Blocked unfinished marker found." >&2
  exit 1
fi

if rg --line-number --with-filename 'fatalError|try!|as!' CyberPath; then
  echo "Blocked unsafe Swift pattern found." >&2
  exit 1
fi

if rg --hidden --line-number --with-filename --glob '!.git/**' --glob '!scripts/ci/validate_structure.sh' --glob '!scripts/ci/validate_structure.ps1' 'BEGIN CERTIFICATE|BEGIN .*PRIVATE KEY' .; then
  echo "Potential signing secret committed to source." >&2
  exit 1
fi

echo "CyberPath iOS governed structure validation passed."
