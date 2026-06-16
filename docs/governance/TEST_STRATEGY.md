# Test Strategy

## Current Test Scope

The current package includes structure validation and Xcode build validation. The app does not yet include a committed XCTest target, so CI uses build verification as the automated compile gate.

## Required Next Test Target

Before production distribution, add a `CyberPathTests` XCTest target covering:

- Progress import validation.
- Progress export format.
- Topic completion persistence.
- Quiz scoring.
- Diagnostic readiness classification.
- Recommendation ordering.
- Scenario evidence persistence.

## UI Acceptance

Simulator acceptance must cover:

- First launch.
- Returning launch with existing progress.
- Dashboard primary action.
- Learn search and filters.
- Topic notes draft save.
- Quiz answer selection and submit.
- Scenario lab decision flow.
- Visual studio canvases.
- Diagnostic completion.
- Evidence report.
- Progress reset, export, and import.

## Accessibility

Manual accessibility review must include:

- VoiceOver labels.
- Dynamic Type.
- Reduce Motion.
- Color contrast.
- Tap target size.
- Logical navigation order.

