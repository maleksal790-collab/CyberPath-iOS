import SwiftUI

struct ReferenceLibraryView: View {
    var body: some View {
        List {
            Section("Glossary") {
                ForEach(GlossaryData.terms) { term in
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

            Section("Ports") {
                ForEach(PortReferenceData.items) { item in
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

            Section("Frameworks") {
                ForEach(FrameworkReferenceData.frameworks) { framework in
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

            Section("Metrics") {
                ForEach(MetricReferenceData.metrics) { metric in
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

            Section("Tools") {
                ForEach(ToolReferenceData.categories) { category in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(category.category)
                            .font(.headline)
                        FlowTags(values: category.tools)
                    }
                    .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("Reference")
    }
}
