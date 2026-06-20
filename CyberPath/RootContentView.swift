import SwiftUI

struct RootContentView: View {
    var body: some View {
        TabView {
            NavigationStack {
                DashboardView()
            }
            .tabItem { Label("Home", systemImage: "house.fill") }

            NavigationStack {
                DomainsView()
            }
            .tabItem { Label("Learn", systemImage: "book.closed.fill") }

            NavigationStack {
                ReferenceLibraryView()
            }
            .tabItem { Label("Reference", systemImage: "list.bullet.rectangle.portrait") }

            NavigationStack {
                ScenarioListView()
            }
            .tabItem { Label("Practice", systemImage: "flask.fill") }

            NavigationStack {
                VisualStudioView()
            }
            .tabItem { Label("Visuals", systemImage: "chart.xyaxis.line") }

            NavigationStack {
                ProgressDashboardView()
            }
            .tabItem { Label("Progress", systemImage: "gauge.with.dots.needle.bottom.50percent") }
        }
        .tint(.cyan)
    }
}
