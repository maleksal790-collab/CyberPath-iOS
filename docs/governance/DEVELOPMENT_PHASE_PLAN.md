# Development Phase Plan

## Purpose

This plan defines when to add content, features, UX improvements, and build validation without creating a large, risky rewrite.

## Phase Sequence

| Phase | Purpose | Build Timing |
|---|---|---|
| 0. Governance | Define clean delivery rules | No Xcode required |
| 1. Build-readiness | Prepare verification scripts and review gates | Prepared, not executed |
| 2. Model expansion | Make Swift models capable of full web content | Static review; Xcode optional if available |
| 3. Content migration | Port roadmap/support content from web | Static review and content checks |
| 4. UX/interface | Add dashboard/topic/glossary/tools/quiz improvements | Xcode strongly recommended |
| 5. Pre-Xcode stabilization | Review call sites, navigation, persistence, content completeness | Prepare mandatory Xcode run |
| 6. Xcode validation | Build and launch in Simulator | Mandatory before finalization |
| 7. Release readiness | TestFlight/App Store prep | Requires successful Xcode phase |

## Phase 0: Governance

Add policies, plans, and checklists. No Swift code changes.

Exit criteria:

- [ ] Governance docs exist.
- [ ] Web/iOS parity approach is documented.
- [ ] Content migration approach is documented.
- [ ] Validation language is standardized.

## Phase 1: Build-Readiness

Improve confidence before heavy Swift changes.

Exit criteria:

- [ ] `VERIFY_ON_MACOS.sh` exists.
- [ ] Xcode command is documented.
- [ ] Build status language is clear.
- [ ] CI and manual validation expectations are documented.

## Phase 2: Model Expansion

Prepare iOS to accept full web content.

Expected changes:

- `deepDive: [String]`
- `relatedTopicIds: [String]`
- `quiz: [QuizQuestion]`
- support models for glossary, ports, frameworks, metrics, and tools

Exit criteria:

- [ ] All model initializers are updated.
- [ ] UI references to changed fields are updated.
- [ ] Static review is complete.
- [ ] Xcode status is reported honestly.

## Phase 3: Content Migration

Port content from the Vercel-matched web source.

Exit criteria:

- [ ] Domain/topic parity is documented.
- [ ] Quizzes preserve answer indexes.
- [ ] Deep dives are retained.
- [ ] Glossary/support data is added cleanly.
- [ ] No UI redesign is bundled into the migration unless approved.

## Phase 4: UX/Interface

Make the native app feel polished while respecting iOS conventions.

Candidate improvements:

- Continue Learning card.
- Dashboard progress summary.
- Native topic tabs.
- Deep Dive tab.
- PM Perspective tab.
- Quiz center.
- Glossary screen.
- Cheat sheet screen.
- Frameworks screen.
- Metrics screen.
- Tools screen.
- Empty states and microcopy.

Exit criteria:

- [ ] New screens are reachable.
- [ ] Existing progress behavior is preserved.
- [ ] UI remains native SwiftUI, not copied web layout.
- [ ] Xcode validation is scheduled or executed.

## Phase 5: Pre-Xcode Stabilization

Freeze broad feature changes and prepare for build.

Exit criteria:

- [ ] No known missing required Swift fields.
- [ ] Navigation paths reviewed.
- [ ] Data file inclusion risk reviewed.
- [ ] Progress migration risk reviewed.
- [ ] Final Xcode phase owner is identified.

## Phase 6: Xcode Validation

Run macOS/Xcode build and simulator validation.

Exit criteria:

- [ ] Project lists successfully.
- [ ] Simulator build succeeds.
- [ ] App launches.
- [ ] Core flows pass smoke test.

## Phase 7: Release Readiness

Prepare TestFlight/App Store path.

Exit criteria:

- [ ] Signing team selected.
- [ ] Bundle ID confirmed.
- [ ] Privacy notes prepared.
- [ ] Release notes prepared.
- [ ] Acceptance checklist complete.
