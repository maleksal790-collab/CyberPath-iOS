import SwiftUI

@main
struct CyberPathApp: App {
    @State private var progress = ProgressStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(progress)
        }
    }
}

