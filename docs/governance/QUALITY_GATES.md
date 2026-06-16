# Quality Gates

## Pull Request Gate

- Scope is clear.
- User-facing impact is described.
- Privacy impact is reviewed.
- Accessibility impact is reviewed.
- Risk and rollback are documented.
- Required screenshots or simulator notes are attached for UI changes.

## Automated Gate

- Required files exist.
- App icons are present.
- No committed signing secrets.
- No unfinished markers or unsafe Swift force patterns.
- Xcode project can be listed.
- App builds for iOS Simulator.

## Manual Acceptance Gate

- App launches on simulator.
- Dashboard renders without console/runtime errors.
- Learn tab search and stage filtering work.
- Topic completion, bookmark, quiz, and notes persist after relaunch.
- Scenario lab can generate and save evidence.
- Visual studio interactions save state.
- Diagnostic produces domain readiness results.
- Evidence report displays non-certification disclaimer.
- Progress export/import works with valid data and rejects malformed data.
- VoiceOver labels and keyboard/focus behavior are reviewed.

## Release Gate

- Manual acceptance checklist completed.
- Release notes are current.
- Signing settings are confirmed on macOS/Xcode.
- Archive/export is completed by an authorized Apple Developer account holder.

