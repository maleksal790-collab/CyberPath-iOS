# CyberPath Mobile - Interface Design

## Overview

CyberPath is a local-first cybersecurity learning app that helps users build foundational knowledge across IT, networking, security operations, cloud security, and GRC domains. The app features structured learning paths, quizzes, scenario-based practice, reference materials, and progress tracking.

## Screen List

### Tab 1: Home (Dashboard)
- Welcome header with user greeting
- "Continue Learning" card showing last visited topic
- Three-part focus plan cards (recommended next topics)
- Quick stats row (topics completed, quiz score average, study time)
- "Start Diagnostic" CTA button

### Tab 2: Learn (Domains)
- Domain list with colored cards (IT Fundamentals, Networking, Security Ops, Cloud Security, GRC, Operations)
- Each domain card shows: icon, title, stage badge, summary, topic count, completion progress bar
- **Domain Detail Screen**: topic list with difficulty indicators, time estimates, completion checkmarks
- **Topic Detail Screen**: overview, workplace use, deep dive sections, key terms, quiz section, notes input, bookmark toggle, mark complete button

### Tab 3: Reference
- Searchable reference library with category tabs/segments
- Glossary section: alphabetical term list with definitions
- Ports section: common port numbers with protocol and description
- Frameworks section: comparison cards (NIST, ISO, CIS, etc.)
- Metrics section: security metrics with targets and categories
- Tools section: tool categories with tool lists

### Tab 4: Practice (Scenarios)
- Scenario list with cards showing title and summary
- **Scenario Detail Screen**: evidence items, action choices with scoring
- Decision feedback with score, rationale, and follow-up actions
- Decision brief generation after completing scenario

### Tab 5: Visuals
- Visual lesson list (Risk Treatment, Threat Model, Cloud Architecture)
- Interactive prompt-based exploration
- Canvas-style guided exercises

### Tab 6: Progress
- Journey snapshot with overall completion percentage
- Domain-by-domain progress bars
- Diagnostic readiness scores per domain
- Study session history
- Evidence report view
- Export/Import progress (JSON)
- Reset progress option

## Primary Content and Functionality

### Data (All Local)
- 5+ learning domains with 4+ topics each
- Each topic has: overview, workplace use, deep dive, key terms, quiz questions
- 6 glossary terms
- Port reference data
- Framework comparisons
- Security metrics
- Tool landscape categories
- 2+ branching scenarios with evidence and scored actions
- 3 visual lessons
- 20-question diagnostic assessment

### Core Functionality
- Topic completion tracking (AsyncStorage)
- Bookmarking topics
- Quiz taking with immediate feedback
- Personal notes per topic
- Diagnostic assessment with readiness scoring
- Scenario-based decision making with scoring
- Progress export/import as JSON
- Study session logging
- Local reset capability

## Key User Flows

### Learning Flow
1. User opens Learn tab → sees domain cards
2. Taps domain → sees topic list with progress
3. Taps topic → reads overview, deep dive, key terms
4. Takes quiz → sees result and explanation
5. Marks topic complete → progress updates
6. Returns to domain → sees updated progress bar

### Diagnostic Flow
1. User taps "Start Diagnostic" on Dashboard
2. Answers 20 cross-domain questions
3. Sees readiness scores per domain (Emerging/Developing/Ready)
4. Scores saved locally and shown on Progress tab

### Scenario Flow
1. User opens Practice tab → sees scenario list
2. Taps scenario → reads summary and evidence
3. Chooses action → sees score and feedback
4. Reviews follow-up actions (recommended vs not)
5. Attempt saved to progress history

### Progress Flow
1. User opens Progress tab → sees journey snapshot
2. Views domain completion bars
3. Views diagnostic scores
4. Can export progress as JSON
5. Can import previous progress
6. Can reset all progress

## Color Choices

| Token | Light | Dark | Purpose |
|-------|-------|------|---------|
| primary | #06b6d4 (Cyan 500) | #22d3ee (Cyan 400) | Main accent, matches cybersecurity/tech feel |
| background | #0f172a (Slate 900) | #020617 (Slate 950) | Dark-first design for cyber aesthetic |
| surface | #1e293b (Slate 800) | #0f172a (Slate 900) | Cards and elevated surfaces |
| foreground | #f1f5f9 (Slate 100) | #e2e8f0 (Slate 200) | Primary text |
| muted | #94a3b8 (Slate 400) | #64748b (Slate 500) | Secondary text |
| border | #334155 (Slate 700) | #1e293b (Slate 800) | Borders and dividers |
| success | #10b981 (Emerald 500) | #34d399 (Emerald 400) | Completion, correct answers |
| warning | #f59e0b (Amber 500) | #fbbf24 (Amber 400) | In-progress states |
| error | #ef4444 (Red 500) | #f87171 (Red 400) | Wrong answers, alerts |

**Design Philosophy**: Dark-first design with cyan accents to evoke a cybersecurity/terminal aesthetic while maintaining readability and iOS HIG compliance.

## Navigation Structure

- Bottom tab bar with 6 tabs (icons + labels)
- Stack navigation within each tab for drill-down screens
- No authentication required (local-first)
- No cloud sync (all AsyncStorage)
