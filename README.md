# CyberPath iOS

Native SwiftUI iOS version of the CyberPath learning app.

This project is separate from the React/Vite web release in `outputs/cyberpath-repaired`. The existing Vercel web/PWA app remains the first launch surface and product/content reference. CyberPath iOS is the native SwiftUI version that will be aligned progressively through governed phases.

## Scope

- Local-first SwiftUI app with no account requirement.
- Dashboard with Continue Learning and a three-part focus plan.
- 18-question cross-domain diagnostic with local readiness scores.
- Learning domain browser with topic detail, notes, bookmarks, completion, and quiz checks.
- Branching scenario lab with generated decision brief.
- Interactive visual studio with risk treatment and threat-model canvas.
- Progress tab with journey snapshot, evidence report, export/import, and local reset.
- App icon and accent color asset catalog included.

## Requirements

- Xcode 15 or newer.
- iOS 17.0 or newer simulator/device.

## Open

Open `CyberPath.xcodeproj` in Xcode, select the `CyberPath` scheme, and run on an iOS simulator.

The current Codex workspace is Windows-based, so Xcode compilation and Simulator validation cannot be executed here. The project files are structured for Xcode on macOS.

## Verify On macOS

```bash
cd outputs/CyberPath-iOS
chmod +x VERIFY_ON_MACOS.sh
./VERIFY_ON_MACOS.sh
```

If your installed simulator name differs from `iPhone 15`, edit the destination in `VERIFY_ON_MACOS.sh` or choose the simulator directly in Xcode.

## Governed Delivery

This package includes a governed delivery structure:

- CI workflow: `.github/workflows/ios-governed-delivery.yml`
- Ownership: `.github/CODEOWNERS`
- Pull request controls: `.github/pull_request_template.md`
- Local validation: `make validate`
- Windows structure validation: `powershell -ExecutionPolicy Bypass -File scripts/ci/validate_structure.ps1`
- Xcode verification: `scripts/ci/verify_xcode.sh`
- Release packaging: `scripts/release/package_release.sh`
- App Store export template: `ExportOptions-AppStore.plist`
- TestFlight/App Store deployment guide: `docs/governance/APP_STORE_CONNECT_DEPLOYMENT.md`
- Governance docs: `docs/governance/`

### Current Governance Planning Docs

- `docs/governance/GOVERNANCE.md`
- `docs/governance/DEVELOPMENT_PHASE_PLAN.md`
- `docs/governance/WEB_IOS_PARITY_PLAN.md`
- `docs/governance/CONTENT_MIGRATION_PLAN.md`
- `docs/governance/VALIDATION_CHECKLIST.md`
- `docs/governance/XCODE_PHASE_PLAN.md`

The current package has no third-party runtime dependencies. Xcode build, simulator validation, signing, and App Store release gates must run on macOS.

## Signing

The bundle identifier is `com.cyberpath.ios`. For device installation or App Store distribution, set your Apple Developer Team in Xcode under the `CyberPath` target signing settings.
