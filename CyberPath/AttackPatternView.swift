import SwiftUI

struct AttackPatternView: View {
    @State private var query = ""
    @State private var selectedCategory = "All"
    @State private var favoritedPatternIDs: Set<String> = []

    private var categories: [String] {
        ["All"] + Array(Set(AttackPatternData.patterns.map(\.category))).sorted()
    }

    private var filteredPatterns: [AttackPattern] {
        AttackPatternData.patterns.filter { pattern in
            let matchesCategory = selectedCategory == "All" || pattern.category == selectedCategory
            let text = "\(pattern.name) \(pattern.abbreviation) \(pattern.description) \(pattern.category) \(pattern.typicalTargets.joined(separator: " "))"
            let matchesQuery = query.isEmpty || text.localizedCaseInsensitiveContains(query)
            return matchesCategory && matchesQuery
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Category", selection: $selectedCategory) {
                    ForEach(categories, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
                .accessibilityLabel("Attack pattern category filter")
            } header: {
                Text("Filter")
            }

            Section {
                if filteredPatterns.isEmpty {
                    ContentUnavailableView(
                        "No patterns match",
                        systemImage: "magnifyingglass",
                        description: Text("Try a broader search or different category.")
                    )
                } else {
                    ForEach(filteredPatterns) { pattern in
                        NavigationLink(value: pattern) {
                            AttackPatternRow(
                                pattern: pattern,
                                isFavorite: favoritedPatternIDs.contains(pattern.id)
                            )
                        }
                    }
                }
            } header: {
                Text("Patterns (\(filteredPatterns.count))")
            }
        }
        .searchable(text: $query, prompt: "Search patterns")
        .navigationTitle("Attack Patterns")
        .navigationDestination(for: AttackPattern.self) { pattern in
            AttackPatternDetailView(
                pattern: pattern,
                isFavorite: Binding(
                    get: { favoritedPatternIDs.contains(pattern.id) },
                    set: { isFavorite in
                        if isFavorite {
                            favoritedPatternIDs.insert(pattern.id)
                        } else {
                            favoritedPatternIDs.remove(pattern.id)
                        }
                    }
                )
            )
        }
    }
}

struct AttackPatternRow: View {
    let pattern: AttackPattern
    let isFavorite: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(pattern.name)
                        .font(.headline)
                    Text(pattern.abbreviation)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                    Text(pattern.category)
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
            Text(pattern.description)
                .font(.callout)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding(.vertical, 4)
    }
}

struct AttackPatternDetailView: View {
    let pattern: AttackPattern
    @Binding var isFavorite: Bool

    var body: some View {
        List {
            Section("Overview") {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(pattern.name)
                                .font(.title2.weight(.bold))
                            Text(pattern.abbreviation)
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
                    Text(pattern.description)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Pattern Details") {
                ReferenceMetaRow(label: "Category", value: pattern.category)
                ReferenceMetaRow(label: "Source", value: pattern.primarySource)
                if let year = pattern.releaseYear {
                    ReferenceMetaRow(label: "Published", value: String(year))
                }
            }

            Section("Typical Targets") {
                FlowTags(values: pattern.typicalTargets)
            }

            Section("Detection Methods") {
                ForEach(pattern.detectionMethods, id: \.self) { method in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(method)
                            .font(.callout)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("Mitigation Steps") {
                ForEach(pattern.mitigationSteps, id: \.self) { step in
                    VStack(alignment: .leading, spacing: 6) {
                        Text(step)
                            .font(.callout)
                    }
                    .padding(.vertical, 4)
                }
            }

            Section("Security Awareness") {
                HStack {
                    Image(systemName: "person.badge.shield.checkmark")
                        .foregroundStyle(.cyan)
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Related Training")
                            .font(.headline)
                        Text("Review CyberPath topics to understand defenses against \(pattern.abbreviation).")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.tertiary)
                }
            }
        }
        .navigationTitle("Attack Pattern")
    }
}

#Preview {
    NavigationStack {
        AttackPatternView()
    }
}
