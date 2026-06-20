# Content Migration Plan

## Purpose

Move CyberPath learning content from the Vercel-matched web app into the native iOS app without damaging the iOS architecture.

This plan supports the web-first alignment strategy: use the existing Vercel app as the web version, then port its content and experience into native SwiftUI.

## Source

Primary source candidate:

```text
maleksal790-collab/cyberpath/client/src/data/roadmapData.ts
```

This source contains:

- Domains.
- Topics.
- Difficulty.
- Time-to-read.
- Overview text.
- PM perspective.
- Deep-dive lesson content.
- Key terms.
- Related topics.
- Multi-question quizzes.
- Port/protocol cheat sheet.
- Framework comparison.
- Security metrics.
- Glossary.
- Tool/vendor landscape.

## Target

Native iOS target:

```text
maleksal790-collab/CyberPath-iOS
```

Recommended future structure:

```text
CyberPath/Data/RoadmapData.swift
CyberPath/Data/GlossaryData.swift
CyberPath/Data/CheatSheetData.swift
CyberPath/Data/FrameworkData.swift
CyberPath/Data/SecurityMetricsData.swift
CyberPath/Data/ToolLandscapeData.swift
CyberPath/Data/ScenarioData.swift
```

If the Xcode project does not automatically include new Swift files, either update the project file carefully or keep migrated content in existing included files until the Xcode phase.

## Migration Order

### Step 1: Model Readiness

Expand Swift models before importing full content.

Expected changes:

```swift
struct Topic {
    let id: String
    let title: String
    let minutes: Int
    let difficulty: Int
    let overview: String
    let workplaceUse: String
    let deepDive: [String]
    let keyTerms: [String]
    let relatedTopicIds: [String]
    let quiz: [QuizQuestion]
}
```

### Step 2: Roadmap Content

Port:

- Domains.
- Topics.
- Overview.
- PM perspective.
- Deep-dive items.
- Key terms.
- Related topic IDs.
- Quizzes.

### Step 3: Support Content

Port:

- Glossary.
- Port/protocol cheat sheet.
- Framework comparison.
- Security metrics.
- Tool/vendor landscape.

### Step 4: UX Integration

Add screens or sections for:

- Topic tabs.
- Glossary.
- Cheat sheet.
- Frameworks.
- Metrics.
- Tools.
- Quiz center.

### Step 5: Xcode Validation

Run after content/model/UX phases are complete enough to validate as a real app flow.

## Mapping Rules

| Web Field | iOS Field | Rule |
|---|---|---|
| `Domain.id` | `Domain.id` | Preserve |
| `Domain.title` | `Domain.title` | Preserve |
| `Domain.icon` | `Domain.symbol` | Convert to SF Symbol |
| `Domain.color` | `Domain.colorHex` | Preserve |
| `Domain.description` | `Domain.summary` | Preserve/adapt lightly |
| `Topic.timeToRead` | `Topic.minutes` | Parse integer |
| `Topic.pmPerspective` | `Topic.workplaceUse` | Preserve as PM/workplace value |
| `Topic.deepDive[]` | `Topic.deepDive[]` | Preserve |
| `Topic.relatedTopics[]` | `Topic.relatedTopicIds[]` | Preserve IDs |
| `Topic.quiz[]` | `Topic.quiz[]` | Preserve all questions |

## Migration Quality Gates

- [ ] IDs remain stable.
- [ ] No topic is silently dropped.
- [ ] Multi-question quizzes are not reduced to one question unless approved.
- [ ] Deep-dive content is preserved.
- [ ] PM perspective content remains visible in iOS.
- [ ] Support datasets are separated from roadmap data.
- [ ] Xcode build status is not overstated.

## Deferred Checks

Until the delayed Xcode phase, do not claim:

- The app builds.
- The app launches in Simulator.
- The new data files are correctly included in the target.
- Navigation is fully verified.

Those claims require macOS/Xcode validation.
