# Web / iOS Parity Plan

## Decision

Use the existing Vercel live app as the official web/PWA version and the native SwiftUI project as the iOS version.

The goal is one CyberPath product with two clients:

- Web/PWA first for live access and fast validation.
- iOS second for native mobile experience and future TestFlight/App Store delivery.

## Reference Web App

The web app is the product/content reference for:

- Domain and topic structure.
- Learning progression.
- PM perspective content.
- Deep-dive lesson content.
- Glossary.
- Tools/vendor landscape.
- Port/protocol cheat sheet.
- Framework comparison.
- Security metrics.
- Quiz behavior.
- Dashboard/product positioning.

## iOS Translation Rules

| Web Concept | iOS Translation |
|---|---|
| React route | SwiftUI screen/navigation path |
| Tailwind card | Native SwiftUI card component |
| Lucide icon | SF Symbol |
| `timeToRead` string | Integer `minutes` |
| `pmPerspective` | `workplaceUse` or PM Perspective tab |
| `deepDive[]` | Deep Dive section/tab |
| `relatedTopics[]` | Related topic links |
| multi-question quiz | Native quiz array |
| localStorage progress | `UserDefaults`/Codable progress snapshot |

## Do Not Do

- Do not paste React/Tailwind code into SwiftUI.
- Do not force the iOS app to become a web app.
- Do not rebuild a second web app from scratch when the Vercel version already exists.
- Do not mix content migration with large visual redesigns in the same uncontrolled change.

## Parity Levels

### Level 1: Content Parity

The iOS app contains the same core educational data as the web app.

Required:

- Domains.
- Topics.
- Overview.
- PM perspective.
- Deep dive.
- Key terms.
- Related topics.
- Quizzes.

### Level 2: Feature Parity

The iOS app supports equivalent user workflows.

Required:

- Dashboard.
- Domain browser.
- Topic detail.
- Completion tracking.
- Bookmarks.
- Quiz attempt tracking.
- Glossary.
- Cheat sheet.
- Frameworks.
- Metrics.
- Tools landscape.

### Level 3: Experience Parity

The iOS app feels like the same product, but native.

Required:

- Native SwiftUI navigation.
- iOS-friendly layout.
- Good empty states.
- Clear progress feedback.
- Accessible text and controls.
- Consistent terminology with the web app.

## Parity Review Checklist

Before closing a parity phase, confirm:

- [ ] Web source file or route is identified.
- [ ] iOS destination model/screen is identified.
- [ ] No content was compressed unless explicitly accepted.
- [ ] IDs are stable and preserve progress compatibility where possible.
- [ ] New Swift fields are reflected in UI and persistence where needed.
- [ ] Xcode validation status is stated honestly.
