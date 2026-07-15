import SwiftUI

struct ComplianceFrameworkView: View {
    @State private var query = ""
    @State private var selectedScope = "All"
    @State private var selectedFramework: ComplianceFramework?
    @State private var favoritedFrameworkIDs: Set<String> = []

    private var scopes: [String] {
        ["All"] + Array(Set(ComplianceFrameworkData.frameworks.map(\.scope))).sorted()
    }

    private var filteredFrameworks: [ComplianceFramework] {
        ComplianceFrameworkData.frameworks.filter { framework in
            let matchesScope = selectedScope == "All" || framework.scope == selectedScope
            let text = "\(framework.name) \(framework.abbreviation) \(framework.description) \(framework.primaryBody) \(framework.applicableIndustries.joined(separator: " "))"
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
                .accessibilityLabel("Compliance framework scope filter")
            } header: {
                Text("Filter")
            }

            Section {
                if filteredFrameworks.isEmpty {
                    ContentUnavailableView(
                        "No frameworks match",
                        systemImage: "magnifyingglass",
                        description: Text("Try a broader search or different scope.")
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
            } header: {
                Text("Frameworks (\(filteredFrameworks.count))")
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
                        .accessibilityLabel(isFavorite ? "Remove from favorites" : "Add to favorites")
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
                    VStack(alignment: .leading, spacing: 6) {
                        Text(requirement)
                            .font(.callout)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("Learning Path") {
                HStack {
                    Image(systemName: "book.fill")
                        .foregroundStyle(.cyan)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Related CyberPath Topics")
                            .font(.headline)
                        Text("Review domains and topics aligned with \(framework.abbreviation).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .navigationTitle("Framework")
    }
}

#Preview {
    NavigationStack {
        ComplianceFrameworkView()
    }
}
