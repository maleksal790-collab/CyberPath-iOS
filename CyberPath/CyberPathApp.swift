import SwiftUI

@main
struct CyberPathApp: App {
    @State private var progressStore = ProgressStore() // Initialize here

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progressStore) // Inject here
        }
    }
}
