import SwiftUI

@main
struct CyberPathApp: App {
    @State private var progressStore = ProgressStore()

    var body: some Scene {
        WindowGroup {
            RootContentView()
                .environment(progressStore)
        }
    }
}
