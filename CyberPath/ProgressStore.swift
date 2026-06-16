import Foundation
import SwiftUI // Ensure SwiftUI is imported

enum ProgressError: Error {
    case importFailed(String)
}

@Observable final class ProgressStore { // Use @Observable macro here
    var progress: Double = 0.0 
    // ... rest of your code
}

import Foundation
import Combine

enum ProgressError: Error {
    case importFailed(String)
}

final class ProgressStore: ObservableObject {
    private let storageKey = "CyberPathProgress"
    @Published var progress: Double = 0.0 

    func importJSON(_ json: String) -> Result<String, ProgressError> {
        guard let data = json.data(using: .utf8) else {
            return .failure(.importFailed("Import text is not valid UTF-8."))
        }
        
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        
        return .success("Import successful")
    }
    
    func saveProgress(snapshot: [String: Any]) {
        if let data = try? JSONEncoder().encode(String(describing: snapshot)) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }
}
