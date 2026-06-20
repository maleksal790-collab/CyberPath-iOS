# CyberPath iOS Governance

## Purpose

CyberPath iOS is governed as a native SwiftUI learning product that must stay aligned with the Vercel web/PWA version while preserving a clean iOS technical structure.

This governance model separates planning, content migration, interface work, build validation, and release readiness so the project can expand without accumulating uncontrolled risk.

## Product Surfaces

| Surface | Role | Source of Truth |
|---|---|---|
| Vercel Web/PWA | First launch surface and UX/content reference | `maleksal790-collab/cyberpath` deployed through Vercel |
| CyberPath iOS | Native SwiftUI app using the same product direction | `maleksal790-collab/CyberPath-iOS` |

The web app is not copied directly into SwiftUI. Web content and feature intent are translated into native iOS models, screens, and interactions.

## Change Categories

| Category | Examples | Required Gate |
|---|---|---|
| Governance | docs, checklists, delivery policy | Documentation review |
| Build-readiness | verification scripts, project structure notes | Static review; macOS build delayed until build gate |
| Model expansion | Swift models for deep dives, related topics, multi-question quizzes | Focused code review |
| Content migration | domains, topics, glossary, tools, metrics, frameworks | Content parity review |
| UX/interface | dashboard, topic tabs, quiz center, glossary, native navigation | Product/UX review |
| Xcode validation | simulator build, app launch, navigation, persistence | macOS/Xcode gate |
| Release readiness | TestFlight/App Store checklist | Release approval |

## Branching Rules

- Use focused feature branches.
- Do not mix governance, model expansion, content migration, and UX redesign in one uncontrolled commit.
- Prefer small pull requests with clear rollback boundaries.
- Keep `main` releasable or clearly marked when it is not release-ready.
- Xcode validation is delayed during early expansion, but it remains mandatory before final release readiness.

## Review Rules

Every pull request should state:

1. Scope.
2. Files changed.
3. Impacted product surface: web, iOS, or both.
4. Whether Swift model compatibility changed.
5. Whether Xcode was run.
6. Known risks and deferred checks.
7. Rollback approach.

## Clean Work Principle

The app should expand in this order:

1. Governance foundation.
2. Build-readiness preparation.
3. Swift model expansion.
4. Content migration.
5. UX/interface development.
6. Pre-Xcode stabilization.
7. Full Xcode build and simulator validation.
8. TestFlight/App Store readiness.

This avoids a large rewrite and prevents silent compile risk from accumulating beyond reviewable boundaries.
