import SwiftUI

struct ReferenceLibraryView: View {
    @State private var query = ""
    @State private var selectedCategory = ReferenceCategory.all
    @State private var sortMode = ReferenceSortMode.defaultOrder

    private enum ReferenceCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case glossary = "Glossary"
        case ports = "Ports"
        case frameworks = "Frameworks"
        case metrics = "Metrics"
        case tools = "Tools"

        var id: String { rawValue }
    }

    private enum ReferenceSortMode: String, CaseIterable, Identifiable {
        case defaultOrder = "Default"
        case sorted = "Sorted"

        var id: String { rawValue }
    }

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var glossaryTerms: [GlossaryTerm] {
        let filtered = GlossaryData.terms.filter { term in
            matchesCategory(.glossary) && matchesQuery([term.term, term.definition, term.relatedDomainIds.joined(separator: " ")])
        }
        return sortMode == .sorted ? filtered.sorted { $0.term.localizedCaseInsensitiveCompare($1.term) == .orderedAscending } : filtered
    }

    private var portItems: [PortCheatSheetItem] {
        let filtered = PortReferenceData.items.filter { item in
            matchesCategory(.ports) && matchesQuery(["Port \(item.port)", item.transportProtocol, item.description])
        }
        return sortMode == .sorted ? filtered.sorted { $0.port < $1.port } : filtered
    }

    private var frameworks: [FrameworkComparison] {
        let filtered = FrameworkReferenceData.frameworks.filter { framework in
            matchesCategory(.frameworks) && matchesQuery([framework.framework, framework.scope, framework.approach, framework.structure, framework.bestFor])
        }
        return sortMode == .sorted ? filtered.sorted { $0.framework.localizedCaseInsensitiveCompare($1.framework) == .orderedAscending } : filtered
    }

    private var metrics: [SecurityMetric] {
        let filtered = MetricReferenceData.metrics.filter { metric in
            matchesCategory(.metrics) && matchesQuery([metric.metric, metric.fullName, metric.description, metric.target, metric.category])
        }
        return sortMode == .sorted ? filtered.sorted { $0.metric.localizedCaseInsensitiveCompare($1.metric) == .orderedAscending } : filtered
    }

    private var toolCategories: [ToolLandscapeCategory] {
        let filtered = ToolReferenceData.categories.filter { category in
            matchesCategory(.tools) && matchesQuery([category.category, category.tools.joined(separator: " ")])
        }
        return sortMode == .sorted ? filtered.sorted { $0.category.localizedCaseInsensitiveCompare($1.category) == .orderedAscending } : filtered
    }

    private var hasResults: Bool {
        !glossaryTerms.isEmpty || !portItems.isEmpty || !frameworks.isEmpty || !metrics.isEmpty || !toolCategories.isEmpty
    }

    private var visibleReferenceCount: Int {
        glossaryTerms.count + portItems.count + frameworks.count + metrics.count + toolCategories.count
    }

    private var totalReferenceCount: Int {
        GlossaryData.terms.count
        + PortReferenceData.items.count
        + FrameworkReferenceData.frameworks.count
        + MetricReferenceData.metrics.count
        + ToolReferenceData.categories.count
    }

    private var filterSummary: String {
        switch (selectedCategory, trimmedQuery.isEmpty) {
        case (.all, true):
            return "Showing all reference categories."
        case (.all, false):
            return "Searching all categories for \"\(trimmedQuery)\"."
        case (_, true):
            return "Showing \(selectedCategory.rawValue.lowercased()) entries."
        case (_, false):
            return "Searching \(selectedCategory.rawValue.lowercased()) for \"\(trimmedQuery)\"."
        }
    }

    private var resultSummary: String {
        let entryLabel = visibleReferenceCount == 1 ? "entry" : "entries"

        if hasActiveFilters {
            return "\(visibleReferenceCount) \(entryLabel) match the current reference controls."
        }

        return "\(visibleReferenceCount) \(entryLabel) available across the full reference library."
    }

    private var hasActiveFilters: Bool {
        !trimmedQuery.isEmpty || selectedCategory != .all || sortMode != .defaultOrder
    }

    private var emptyStateDescription: String {
        switch (selectedCategory, trimmedQuery.isEmpty) {
        case (.all, true):
            return "No reference entries are available yet."
        case (.all, false):
            return "No entries matched \"\(trimmedQuery)\". Try a broader search term."
        case (_, true):
            return "No \(selectedCategory.rawValue.lowercased()) entries are available yet. Try another category."
        case (_, false):
            return "No \(selectedCategory.rawValue.lowercased()) entries matched \"\(trimmedQuery)\". Try clearing the search or changing category."
        }
    }

    var body: some View {
        List {
            Section {
                ReferenceOverviewHeader(
                    visibleCount: visibleReferenceCount,
                    totalCount: totalReferenceCount,
                    categoryLabel: selectedCategory.rawValue,
                    sortLabel: sortMode.rawValue,
                    filterSummary: filterSummary
                )
            }

            Section {
                ReferenceGuidanceCard()
            }

            Section {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ReferenceCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.menu)
                .accessibilityLabel("Reference category filter")
                .accessibilityValue(selectedCategory.rawValue)

                Picker("Sort", selection: $sortMode) {
                    ForEach(ReferenceSortMode.allCases) { mode in
                        Text(mode.rawValue).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Reference sort mode")
                .accessibilityValue(sortMode.rawValue)
            }

            if hasResults {
                Section {
                    Label(resultSummary, systemImage: "checklist")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .accessibilityLabel(resultSummary)
                }
            }

            if !hasResults {
                Section("No matches") {
                    ContentUnavailableView(
                        "No reference entries found",
                        systemImage: "magnifyingglass",
                        description: Text(emptyStateDescription)
                    )
                }
            }

            if !glossaryTerms.isEmpty {
                Section("Glossary (\(glossaryTerms.count))") {
                    ForEach(glossaryTerms) { term in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(term.term)
                                .font(.headline)
                            Text(term.definition)
                                .font(.callout)
                                .foregroundStyle(.secondary)
                            if !term.relatedDomainIds.isEmpty {
                                FlowTags(values: term.relatedDomainIds)
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
            }

            if !portItems.isEmpty {
                Section("Ports (\(portItems.count))") {
                    ForEach(portItems) { item in
                        DisclosureGroup {
                            ReferenceMetaRow(label: "Transport", value: item.transportProtocol)
                            ReferenceMetaRow(label: "TCP based", value: item.usesTCP ? "Yes" : "No")
                            ReferenceMetaRow(label: "Use", value: item.description)
                        } label: {
                            HStack(alignment: .top) {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Port \(item.port)")
                                        .font(.headline)
                                    Text(item.description)
                                        .font(.callout)
                                        .foregroundStyle(.secondary)
                                }
                                Spacer()
                                Text(item.transportProtocol)
                                    .font(.caption.weight(.bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.quaternary, in: Capsule())
                            }
                        }
                    }
                }
            }

            if !frameworks.isEmpty {
                Section("Frameworks (\(frameworks.count))") {
                    ForEach(frameworks) { framework in
                        DisclosureGroup {
                            ReferenceMetaRow(label: "Scope", value: framework.scope)
                            ReferenceMetaRow(label: "Approach", value: framework.approach)
                            ReferenceMetaRow(label: "Structure", value: framework.structure)
                            ReferenceMetaRow(label: "Best for", value: framework.bestFor)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(framework.framework)
                                    .font(.headline)
                                Text(framework.scope)
                                Text(framework.bestFor)
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            if !metrics.isEmpty {
                Section("Metrics (\(metrics.count))") {
                    ForEach(metrics) { metric in
                        DisclosureGroup {
                            ReferenceMetaRow(label: "Full name", value: metric.fullName)
                            ReferenceMetaRow(label: "Category", value: metric.category)
                            ReferenceMetaRow(label: "Target", value: metric.target)
                            ReferenceMetaRow(label: "Description", value: metric.description)
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(metric.metric)
                                    .font(.headline)
                                Text(metric.fullName)
                                    .font(.subheadline)
                                Text(metric.description)
                                    .font(.callout)
                                    .foregroundStyle(.secondary)
                                Text(metric.category)
                                    .font(.caption.weight(.bold))
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(.quaternary, in: Capsule())
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }

            if !toolCategories.isEmpty {
                Section("Tools (\(toolCategories.count))") {
                    ForEach(toolCategories) { category in
                        DisclosureGroup {
                            ForEach(category.tools, id: \.self) { tool in
                                Label(tool, systemImage: "checkmark.circle")
                            }
                        } label: {
                            VStack(alignment: .leading, spacing: 8) {
                                Text(category.category)
                                    .font(.headline)
                                FlowTags(values: category.tools)
                            }
                            .padding(.vertical, 4)
                        }
                    }
                }
            }
        }
        .searchable(text: $query, prompt: "Search reference")
        .navigationTitle("Reference")
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("Reset") {
                    resetFilters()
                }
                .disabled(!hasActiveFilters)
                .accessibilityLabel("Reset reference filters")
                .accessibilityHint("Clears the search, category, and sort mode")
            }
        }
    }

    private func resetFilters() {
        query = ""
        selectedCategory = .all
        sortMode = .defaultOrder
    }

    private func matchesCategory(_ category: ReferenceCategory) -> Bool {
        selectedCategory == .all || selectedCategory == category
    }

    private func matchesQuery(_ values: [String]) -> Bool {
        guard !trimmedQuery.isEmpty else { return true }
        return values.joined(separator: " ").localizedCaseInsensitiveContains(trimmedQuery)
    }
}

private struct ReferenceOverviewHeader: View {
    let visibleCount: Int
    let totalCount: Int
    let categoryLabel: String
    let sortLabel: String
    let filterSummary: String

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            Label("Reference library", systemImage: "list.bullet.rectangle.portrait")
                .font(.headline)
                .foregroundStyle(.cyan)

            Text(filterSummary)
                .font(.callout)
                .foregroundStyle(.secondary)

            LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 10) {
                ReferenceOverviewTile(value: "\(visibleCount)", label: "Visible")
                ReferenceOverviewTile(value: "\(totalCount)", label: "Total")
                ReferenceOverviewTile(value: categoryLabel, label: "Category")
                ReferenceOverviewTile(value: sortLabel, label: "Sort")
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ReferenceGuidanceCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label("How to use this library", systemImage: "lightbulb")
                .font(.headline)
                .foregroundStyle(.cyan)

            VStack(alignment: .leading, spacing: 8) {
                ReferenceGuidanceRow(symbol: "magnifyingglass", text: "Search across visible reference content.")
                ReferenceGuidanceRow(symbol: "line.3.horizontal.decrease.circle", text: "Filter by category when you know the type of item you need.")
                ReferenceGuidanceRow(symbol: "arrow.up.arrow.down", text: "Switch sort mode when scanning a long list.")
                ReferenceGuidanceRow(symbol: "chevron.right.circle", text: "Expand rows to inspect details without leaving the screen.")
            }
        }
        .padding(.vertical, 4)
    }
}

private struct ReferenceGuidanceRow: View {
    let symbol: String
    let text: String

    var body: some View {
        Label(text, systemImage: symbol)
            .font(.caption)
            .foregroundStyle(.secondary)
    }
}

private struct ReferenceOverviewTile: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.headline.weight(.bold))
                .lineLimit(1)
                .minimumScaleFactor(0.75)
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(10)
        .background(.quaternary, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(label): \(value)")
    }
}

private struct ReferenceMetaRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.cyan)
            Text(value)
                .font(.callout)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 4)
    }
}
