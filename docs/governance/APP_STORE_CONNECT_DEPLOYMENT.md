# App Store Connect Deployment

## Required Access

- macOS with Xcode.
- Apple Developer Program membership.
- App Store Connect access for the target team.
- Bundle identifier: `com.cyberpath.ios`.

## TestFlight Flow

1. Open `CyberPath.xcodeproj` in Xcode.
2. Select the `CyberPath` target.
3. Set the Apple Developer Team.
4. Confirm version and build number.
5. Run simulator smoke tests.
6. Archive the app.
7. Export or upload to App Store Connect.
8. Add TestFlight notes and internal testers.
9. Complete acceptance checklist before external testing.

## Command-Line Flow

```bash
./scripts/ci/verify_xcode.sh
./scripts/release/archive_release.sh
./scripts/release/export_appstore.sh
```

Signing automation is intentionally not committed. Use local Xcode signing or encrypted CI secrets.

## Deployment Blockers

Deployment must stop if:

- The app does not build on macOS.
- Simulator smoke testing fails.
- Signing identity is missing or incorrect.
- Privacy answers are incomplete.
- Release notes are missing.
- Acceptance checklist is incomplete.

