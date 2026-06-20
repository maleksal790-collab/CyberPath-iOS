# Validation Checklist

## Purpose

This checklist keeps CyberPath iOS development reviewable while Xcode validation is intentionally delayed until the correct phase.

## Validation Layers

### Layer 1: Governance Validation

Use for docs/pipeline-only changes.

- [ ] Scope is documented.
- [ ] No Swift code was changed.
- [ ] No release claim was made.
- [ ] Next phase is clearly stated.

### Layer 2: Build-Readiness Validation

Use before model/content expansion.

- [ ] Xcode project path is identified.
- [ ] Scheme name is documented.
- [ ] Local macOS verification script exists.
- [ ] GitHub Actions or local build command is documented.
- [ ] Xcode build is marked delayed when not executed.

### Layer 3: Swift Static Review

Use after Swift model or UI changes, before Xcode build.

- [ ] Changed model fields are reflected at call sites.
- [ ] New required properties have values everywhere they are initialized.
- [ ] Singular-to-array changes are updated in UI logic.
- [ ] Navigation destination types remain `Hashable` where required.
- [ ] Persistence/import/export compatibility is considered.
- [ ] No build success is claimed without macOS/Xcode.

### Layer 4: Content Review

Use after roadmap/support content migration.

- [ ] Domain count matches the source plan.
- [ ] Topic count is documented.
- [ ] Key terms are preserved.
- [ ] Deep-dive sections are preserved.
- [ ] PM perspective/workplace-use text is preserved.
- [ ] Quiz answer indexes are verified.
- [ ] Related-topic IDs are valid or documented as unresolved.

### Layer 5: UX Review

Use after interface changes.

- [ ] Dashboard has a clear next action.
- [ ] Topic detail separates Overview, Deep Dive, PM Perspective, and Quiz.
- [ ] Empty states are useful.
- [ ] Progress feedback is visible.
- [ ] Text remains readable on iPhone-size screens.
- [ ] Native iOS controls are used where practical.
- [ ] Accessibility labels and focus order are considered.

### Layer 6: Xcode / Simulator Validation

Delayed until the Xcode phase.

- [ ] `xcodebuild -list -project CyberPath.xcodeproj` succeeds.
- [ ] Simulator build succeeds.
- [ ] App launches.
- [ ] Dashboard loads.
- [ ] Domain list opens.
- [ ] Topic detail opens.
- [ ] Completion toggles persist.
- [ ] Bookmarks persist.
- [ ] Quiz scoring works.
- [ ] Notes persist.
- [ ] Export/import works.
- [ ] No critical console/runtime errors are observed.

## Required Status Language

Use these exact status labels in PR summaries:

- `Not applicable` — validation is not relevant to the change.
- `Prepared, not executed` — scripts/checklists exist, but the validation was not run.
- `Static review only` — source was reviewed, but no build was run.
- `Executed on macOS/Xcode` — validation actually ran on macOS/Xcode.

Do not say `build passed` unless Xcode validation actually executed successfully.
