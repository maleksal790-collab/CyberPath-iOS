# Delayed Xcode Phase Plan

## Decision

Xcode validation is delayed, not excluded.

Early phases may proceed without running Xcode only if each pull request clearly states that build validation is prepared but not executed.

## Why Delay Xcode

The current working environment may not have macOS/Xcode available. The project can still be organized, reviewed, and prepared for development, but native build claims require macOS/Xcode.

## When To Expand Build Validation

Build validation expands in layers:

1. Governance phase: no Xcode required.
2. Build-readiness phase: document commands and scripts; do not require execution.
3. Model expansion phase: static Swift review required; Xcode useful but still optional if unavailable.
4. Content migration phase: static review and data checks required.
5. UX/interface phase: Xcode becomes strongly recommended.
6. Pre-release phase: Xcode build is mandatory.

## Final Xcode Gate

Before any release-ready claim, run:

```bash
./VERIFY_ON_MACOS.sh
```

or manually:

```bash
xcodebuild -list -project CyberPath.xcodeproj
xcodebuild \
  -project CyberPath.xcodeproj \
  -scheme CyberPath \
  -destination 'platform=iOS Simulator,name=iPhone 15' \
  build
```

## Simulator Smoke Test

After build succeeds:

- [ ] Launch app.
- [ ] Confirm dashboard renders.
- [ ] Open a domain.
- [ ] Open a topic.
- [ ] Toggle completion.
- [ ] Toggle bookmark.
- [ ] Attempt quiz.
- [ ] Add note if notes are present.
- [ ] Check progress tab.
- [ ] Export progress.
- [ ] Reset and import progress.

## Stop Conditions

Stop finalization if:

- Xcode project listing fails.
- Simulator build fails.
- App does not launch.
- Navigation crashes.
- Progress persistence fails.
- Quiz scoring fails.
- Required release documentation is incomplete.

## Reporting Rule

Every PR after model expansion must include one of these statements:

- `Xcode validation: not applicable`
- `Xcode validation: prepared, not executed`
- `Xcode validation: static review only`
- `Xcode validation: executed on macOS/Xcode`
