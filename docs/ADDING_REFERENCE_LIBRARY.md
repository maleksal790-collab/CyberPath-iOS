# Adding a New Reference Library to CyberPath iOS

This guide provides step-by-step instructions for adding a new reference library to the CyberPath iOS app. It uses **Compliance Frameworks** as a working example that you can copy and adapt.

---

## Table of Contents

1. [Overview](#overview)
2. [Step 1: Define the Data Model](#step-1-define-the-data-model)
3. [Step 2: Create Views](#step-2-create-views)
4. [Step 3: Integrate into ReferenceLibraryView](#step-3-integrate-into-referencelibrary-view)
5. [Step 4: Update Validation Scripts](#step-4-update-validation-scripts)
6. [Step 5: Optional — Add Persistence](#step-5-optional--add-persistence)
7. [Testing Checklist](#testing-checklist)
8. [Performance Tips](#performance-tips)

---

## Overview

A reference library in CyberPath consists of:

| Component | File | Purpose |
|-----------|------|---------|
| **Data Model** | `Models.swift` | Swift `struct` with `Identifiable`, `Hashable`, `Codable` |
| **Data Source** | `[Name]Data.swift` | `enum` with static `Array<Model>` |
| **Views** | `[Name]View.swift` | List view, row view, detail view |
| **Integration** | `ReferenceLibraryView.swift` | Category enum, computed properties, rendering |
| **Validation** | `scripts/ci/*.sh`, `*.ps1` | File existence checks |
| **Persistence** (optional) | `Models.swift`, `ProgressStore.swift` | User bookmarks/notes |

**Key Design Principles:**
- ✅ **Searchable**: Every entry matches against multiple text fields
- ✅ **Filterable**: Category picker + scope/type filter
- ✅ **Favoriteable**: Session-based (not persisted) star button
- ✅ **Discoverable**: Disclosure groups expand to show details
- ✅ **Accessible**: VoiceOver labels, keyboard navigation

---

## Step 1: Define the Data Model

Create a new file: **`CyberPath/[Name]Data.swift`**

### Requirements

- ✅ Conform to `Identifiable` (provide `id: String`)
- ✅ Conform to `Hashable` (for Set operations, NavigationLink)
- ✅ Conform to `Codable` (for future export/import, persistence)
- ✅ Use `String` IDs (hashable, serializable, human-readable)
- ✅ Keep properties simple (String, Int, [String], Bool)

### Example: ComplianceFrameworkData.swift

```swift
import Foundation

/// Represents a compliance or security framework.
struct ComplianceFramework: Identifiable, Hashable, Codable {
    let id: String                      // Unique ID (abbreviation)
    let name: String                    // Full name
    let abbreviation: String            // Short code (e.g., "NIST CSF")
    let scope: String                   // Category for filtering
    let description: String             // Summary
    let keyRequirements: [String]       // Main points/controls
    let applicableIndustries: [String]  // Domains where this applies
    let releaseYear: Int?               // Publication year
    let primaryBody: String             // Issuing organization

    init(
        name: String,
        abbreviation: String,
        scope: String,
        description: String,
        keyRequirements: [String],
        applicableIndustries: [String],
        releaseYear: Int? = nil,
        primaryBody: String
    ) {
        self.id = abbreviation  // Use abbreviation as ID
        self.name = name
        self.abbreviation = abbreviation
        self.scope = scope
        self.description = description
        self.keyRequirements = keyRequirements
        self.applicableIndustries = applicableIndustries
        self.releaseYear = releaseYear
        self.primaryBody = primaryBody
    }
}

enum ComplianceFrameworkData {
    static let frameworks: [ComplianceFramework] = [
        ComplianceFramework(
            name: "NIST Cybersecurity Framework",
            abbreviation: "NIST CSF",
            scope: "Cybersecurity Risk Management",
            description: "Voluntary framework providing guidance on how to manage and reduce cybersecurity risk.",
            keyRequirements: [
                "Identify: Know your assets, risks, and business context.",
                "Protect: Implement safeguards to enable delivery of core services.",
                "Detect: Understand and monitor potential cyber incidents.",
                "Respond: Take planned actions during and after a cyber incident.",
                "Recover: Restore capabilities affected by a cyber incident."
            ],
            applicableIndustries: ["Critical Infrastructure", "Federal", "Private sector", "Any"],
            releaseYear: 2014,
            primaryBody: "NIST"
        ),
        // Add more frameworks...
    ]
}
```

---

## Step 2: Create Views

Create a new file: **`CyberPath/[Name]View.swift`**

The view file should include three views:

### 2.1 — List View (filterable, searchable collection)

```swift
import SwiftUI

struct ComplianceFrameworkView: View {
    @State private var query = ""
    @State private var selectedScope = "All"
    @State private var favoritedFrameworkIDs: Set<String> = []

    private var scopes: [String] {
        ["All"] + Array(Set(ComplianceFrameworkData.frameworks.map(\.scope))).sorted()
    }

    private var filteredFrameworks: [ComplianceFramework] {
        ComplianceFrameworkData.frameworks.filter { framework in
            let matchesScope = selectedScope == "All" || framework.scope == selectedScope
            let text = "\(framework.name) \(framework.abbreviation) \(framework.description)"
            let matchesQuery = query.isEmpty || text.localizedCaseInsensitiveContains(query)
            return matchesScope && matchesQuery
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Scope", selection: $selectedScope) {
                    ForEach(scopes, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
            } header: {
                Text("Filter")
            }

            Section {
                if filteredFrameworks.isEmpty {
                    ContentUnavailableView(
                        "No frameworks match",
                        systemImage: "magnifyingglass",
                        description: Text("Try a broader search.")
                    )
                } else {
                    ForEach(filteredFrameworks) { framework in
                        NavigationLink(value: framework) {
                            ComplianceFrameworkRow(
                                framework: framework,
                                isFavorite: favoritedFrameworkIDs.contains(framework.id)
                            )
                        }
                    }
                }
            }
        }
        .searchable(text: $query, prompt: "Search frameworks")
        .navigationTitle("Compliance Frameworks")
        .navigationDestination(for: ComplianceFramework.self) { framework in
            ComplianceFrameworkDetailView(
                framework: framework,
                isFavorite: Binding(
                    get: { favoritedFrameworkIDs.contains(framework.id) },
                    set: { isFavorite in
                        if isFavorite {
                            favoritedFrameworkIDs.insert(framework.id)
                        } else {
                            favoritedFrameworkIDs.remove(framework.id)
                        }
                    }
                )
            )
        }
    }
}
```

### 2.2 — Row View (single list item)

```swift
struct ComplianceFrameworkRow: View {
    let framework: ComplianceFramework
    let isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(framework.name)
                        .font(.headline)
                    Text(framework.abbreviation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(framework.scope)
                        .font(.caption2)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(.quaternary, in: Capsule())
                }
                Spacer()
                Image(systemName: isFavorite ? "star.fill" : "star")
                    .font(.caption)
                    .foregroundStyle(isFavorite ? .yellow : .secondary)
            }
            Text(framework.description)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}
```

### 2.3 — Detail View (full entry display)

```swift
struct ComplianceFrameworkDetailView: View {
    let framework: ComplianceFramework
    @Binding var isFavorite: Bool

    var body: some View {
        List {
            Section("Overview") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(framework.name)
                                .font(.title2.weight(.bold))
                            Text(framework.abbreviation)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Button(action: { isFavorite.toggle() }) {
                            Image(systemName: isFavorite ? "star.fill" : "star")
                                .font(.title3)
                                .foregroundStyle(isFavorite ? .yellow : .secondary)
                        }
                        .buttonStyle(.plain)
                    }
                    Text(framework.description)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Framework Details") {
                ReferenceMetaRow(label: "Scope", value: framework.scope)
                ReferenceMetaRow(label: "Primary Body", value: framework.primaryBody)
                if let year = framework.releaseYear {
                    ReferenceMetaRow(label: "Released", value: String(year))
                }
            }

            Section("Applicable Industries") {
                FlowTags(values: framework.applicableIndustries)
            }

            Section("Key Requirements") {
                ForEach(framework.keyRequirements, id: \.self) { requirement in
                    Text(requirement)
                        .font(.callout)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Framework")
    }
}
```

---

## Step 3: Integrate into ReferenceLibraryView

Edit **`CyberPath/ReferenceLibraryView.swift`** in three places:

### 3.1 — Add enum case (line ~15)

```swift
private enum ReferenceCategory: String, CaseIterable, Identifiable {
    case all = "All"
    case glossary = "Glossary"
    case ports = "Ports"
    case frameworks = "Frameworks"
    case metrics = "Metrics"
    case tools = "Tools"
    case compliance = "Compliance"  // ← ADD THIS
    
    var id: String { rawValue }
}
```

### 3.2 — Add computed properties (after `toolCategories`, around line ~65)

```swift
private var complianceFrameworks: [ComplianceFramework] {
    let filtered = ComplianceFrameworkData.frameworks.filter { framework in
        matchesCategory(.compliance) && matchesQuery([
            framework.name, 
            framework.abbreviation, 
            framework.description, 
            framework.scope, 
            framework.primaryBody,
            framework.applicableIndustries.joined(separator: " ")
        ])
    }
    return sortMode == .sorted ? filtered.sorted { $0.name.localizedCaseInsensitiveCompare($1.name) == .orderedAscending } : filtered
}
```

### 3.3 — Update count properties (lines ~66-80)

```swift
private var hasResults: Bool {
    !glossaryTerms.isEmpty || !portItems.isEmpty || !frameworks.isEmpty 
    || !metrics.isEmpty || !toolCategories.isEmpty || !complianceFrameworks.isEmpty  // ← ADD
}

private var visibleReferenceCount: Int {
    glossaryTerms.count + portItems.count + frameworks.count + metrics.count 
    + toolCategories.count + complianceFrameworks.count  // ← ADD
}

private var totalReferenceCount: Int {
    GlossaryData.terms.count
    + PortReferenceData.items.count
    + FrameworkReferenceData.frameworks.count
    + MetricReferenceData.metrics.count
    + ToolReferenceData.categories.count
    + ComplianceFrameworkData.frameworks.count  // ← ADD
}
```

### 3.4 — Add rendering section (after toolCategories, around line ~340)

```swift
if !complianceFrameworks.isEmpty {
    Section("Compliance Frameworks (\(complianceFrameworks.count))") {
        ForEach(complianceFrameworks) { framework in
            DisclosureGroup {
                ReferenceMetaRow(label: "Scope", value: framework.scope)
                ReferenceMetaRow(label: "Primary Body", value: framework.primaryBody)
                if let year = framework.releaseYear {
                    ReferenceMetaRow(label: "Released", value: String(year))
                }
                if !framework.applicableIndustries.isEmpty {
                    ReferenceMetaRow(label: "Industries", value: framework.applicableIndustries.joined(separator: ", "))
                }
            } label: {
                HStack(alignment: .top, spacing: 12) {
                    VStack(alignment: .leading, spacing: 6) {
                        Text(framework.name)
                            .font(.headline)
                        Text(framework.abbreviation)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.vertical, 4)
                    Spacer()
                    FavoriteReferenceButton(
                        isFavorite: isFavorite(referenceID: favoriteID("compliance", framework.id)),
                        label: framework.abbreviation
                    ) {
                        toggleFavorite(referenceID: favoriteID("compliance", framework.id))
                    }
                }
            }
        }
    }
}
```

---

## Step 4: Update Validation Scripts

### 4.1 — Bash script (`scripts/ci/validate_structure.sh`)

Add these two lines around line 10 (in the `required_files` array):

```bash
"CyberPath/ComplianceFrameworkData.swift"
"CyberPath/ComplianceFrameworkView.swift"
```

### 4.2 — PowerShell script (`scripts/ci/validate_structure.ps1`)

Add these two lines around line 10 (in the `$requiredFiles` array):

```powershell
"CyberPath\ComplianceFrameworkData.swift",
"CyberPath\ComplianceFrameworkView.swift"
```

---

## Step 5: Optional — Add Persistence

If users should be able to bookmark or save notes on entries, follow these steps:

### 5.1 — Extend ProgressSnapshot (`Models.swift`)

Add these fields to the `ProgressSnapshot` struct (around line ~215):

```swift
struct ProgressSnapshot: Codable {
    // ... existing fields ...
    var savedComplianceFrameworkIds: Set<String> = []
    var complianceFrameworkNotes: [String: String] = [:]
}
```

### 5.2 — Add methods to ProgressStore (`ProgressStore.swift`)

Add these methods (around line ~230, after the scenarios section):

```swift
// MARK: - Compliance Frameworks

func toggleSavedComplianceFramework(_ framework: ComplianceFramework) {
    if snapshot.savedComplianceFrameworkIds.contains(framework.id) {
        snapshot.savedComplianceFrameworkIds.remove(framework.id)
    } else {
        snapshot.savedComplianceFrameworkIds.insert(framework.id)
    }
    save()
}

func isSavedComplianceFramework(_ framework: ComplianceFramework) -> Bool {
    snapshot.savedComplianceFrameworkIds.contains(framework.id)
}

func saveComplianceFrameworkNote(_ text: String, for framework: ComplianceFramework) {
    snapshot.complianceFrameworkNotes[framework.id] = text.isEmpty ? nil : text
    save()
}

func complianceFrameworkNote(for framework: ComplianceFramework) -> String {
    snapshot.complianceFrameworkNotes[framework.id] ?? ""
}
```

### 5.3 — Update detail view to use ProgressStore

```swift
struct ComplianceFrameworkDetailView: View {
    let framework: ComplianceFramework
    @Binding var isFavorite: Bool
    @Environment(ProgressStore.self) private var progress  // ← ADD
    @State private var noteDraft = ""  // ← ADD

    var body: some View {
        List {
            // ... existing sections ...
            
            Section("My notes") {  // ← ADD
                TextEditor(text: $noteDraft)
                    .frame(minHeight: 120)
                    .onChange(of: noteDraft) { _, newValue in
                        progress.saveComplianceFrameworkNote(newValue, for: framework)
                    }
            }
        }
        .onAppear {  // ← ADD
            noteDraft = progress.complianceFrameworkNote(for: framework)
        }
    }
}
```

---

## Testing Checklist

- [ ] **Build**: `make build` succeeds without errors
- [ ] **Validate**: `make validate` passes all structure checks
- [ ] **Search**: Search by name, abbreviation, description in all categories
- [ ] **Filter**: Filter by scope/category and verify correct entries display
- [ ] **Navigation**: Tap entry → detail view opens with full information
- [ ] **Favorites**: Click star button → visual feedback (session-based, not persisted)
- [ ] **Empty State**: Search with no matches → "No frameworks match" message
- [ ] **Accessibility**: Test with VoiceOver enabled
- [ ] **Persistence** (if enabled): Save note → relaunch app → note persists

---

## Performance Tips

1. **Keep data arrays under 1000 items** — SwiftUI List is efficient, but very large arrays impact initial load
2. **Use lazy evaluation** — Filter and sort in computed properties, not in `body`
3. **Avoid heavy calculations in row views** — Keep rows simple for smooth scrolling
4. **Cache searchable text** — If you have >500 entries, pre-compute searchable strings in data init
5. **Throttle search** — For very large datasets, consider debouncing the search query

---

## Future Enhancements

- **Framework Cross-References** — Link "NIST CSF" ↔ "ISO 27001" with explanations
- **Comparison View** — Side-by-side comparison of 2-3 frameworks
- **PDF Export** — Export selected frameworks + notes as PDF
- **Learning Links** — Associate frameworks with specific CyberPath topics
- **Version History** — Track framework updates over time
- **CloudKit Sync** — Sync bookmarks and notes across Apple devices

---

## Example: Full Working Pattern

**File: `CyberPath/ComplianceFrameworkData.swift`**
- ✅ Defines `ComplianceFramework` struct (6 KB)
- ✅ Provides 5 example frameworks with realistic data
- ✅ Uses string IDs, arrays of strings, optional integers

**File: `CyberPath/ComplianceFrameworkView.swift`**
- ✅ Implements `ComplianceFrameworkView` (searchable list)
- ✅ Implements `ComplianceFrameworkRow` (list item)
- ✅ Implements `ComplianceFrameworkDetailView` (detail screen)
- ✅ Supports favorites (session-based)

**Integration: `CyberPath/ReferenceLibraryView.swift`**
- ✅ Added `.compliance` case to enum
- ✅ Added `complianceFrameworks` computed property
- ✅ Updated `hasResults`, `visibleReferenceCount`, `totalReferenceCount`
- ✅ Added rendering section with disclosure groups

**Validation: `scripts/ci/*.sh` + `*.ps1`**
- ✅ Both files added to required_files lists

**Result**: New reference category available in the app immediately after merge.

---

## Questions?

If you're adding a different type of reference (e.g., **Attack Patterns**, **Security Controls**, **Cloud Services**), the pattern is identical:

1. Create `[Name]Data.swift` with struct + enum
2. Create `[Name]View.swift` with List + Row + Detail views
3. Add enum case and computed properties to `ReferenceLibraryView.swift`
4. Update validation scripts
5. Test and merge

Good luck! 🚀
