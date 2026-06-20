import SwiftUI

struct ReferenceLibraryView: View {
    @State private var query = ""
    @State private var selectedCategory = ReferenceCategory.all

    private enum ReferenceCategory: String, CaseIterable, Identifiable {
        case all = "All"
        case glossary = "Glossary"
        case ports = "Ports"
        case frameworks = "Frameworks"
        case metrics = "Metrics"
        case tools = "Tools"

        var id: String { rawValue }
    }

    private var trimmedQuery: String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    private var glossaryTerms: [GlossaryTerm] {
        GlossaryData.terms.filter { term in
            matchesCategory(.glossary) && matchesQuery([term.term, term.definition, term.relatedDomainIds.joined(separator: " ")])
        }
    }

    private var portItems: [PortCheatSheetItem] {
        PortReferenceData.items.filter { item in
            matchesCategory(.ports) && matchesQuery(["Port \(item.port)", item.transportProtocol, item.description])
        }
    }

    private var frameworks: [FrameworkComparison] {
        FrameworkReferenceData.frameworks.filter { framework in
            matchesCategory(.frameworks) && matchesQuery([framework.framework, framework.scope, framework.approach, framework.structure, framework.bestFor])
        }
    }

    private var metrics: [SecurityMetric] {
        MetricReferenceData.metrics.filter { metric in
            matchesCategory(.metrics) && matchesQuery([metric.metric, metric.fullName, metric.description, metric.target, metric.category])
        }
    }

    private var toolCategories: [ToolLandscapeCategory] {
        ToolReferenceData.categories.filter { category in
            matchesCategory(.tools) && matchesQuery([category.category, category.tools.joined(separator: " ")])
        }
    }

    private var hasResults: Bool {
        !glossaryTerms.isEmpty || !portItems.isEmpty || !frameworks.isEmpty || !metrics.isEmpty || !toolCategories.isEmpty
    }

    var body: some View {
        List {
            Section {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(ReferenceCategory.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.menu)
            }

            if !hasResults {
                Section("No matches") {
                    ContentUnavailableView(
                        "No reference entries found",
                        systemImage: "magnifyingglass",
                        description: Text("Try a different search term or category.")
                    )
                }
            }

            if !glossaryTerms.isEmpty {
                Section("Glossary") {
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
                Section("Ports") {
                    ForEach(portItems) { item in
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

            if !frameworks.isEmpty {
                Section("Frameworks") {
                    ForEach(frameworks) { framework in
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

            if !metrics.isEmpty {
                Section("Metrics") {
                    ForEach(metrics) { metric in
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

            if !toolCategories.isEmpty {
                Section("Tools") {
                    ForEach(toolCategories) { category in
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
        .searchable(text: $query, prompt: "Search reference")
        .navigationTitle("Reference")
    }

    private func matchesCategory(_ category: ReferenceCategory) -> Bool {
        selectedCategory == .all || selectedCategory == category
    }

    private func matchesQuery(_ values: [String]) -> Bool {
        guard !trimmedQuery.isEmpty else { return true }
        return values.joined(separator: " ").localizedCaseInsensitiveContains(trimmedQuery)
    }
}
