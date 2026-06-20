import Foundation
import Observation

@Observable final class ProgressStore {
    private let storageKey = "CyberPathProgress"
    var snapshot: ProgressSnapshot = ProgressSnapshot()

    init() {
        load()
    }

    // MARK: - Persistence

    private func load() {
        if let data = UserDefaults.standard.data(forKey: storageKey) {
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            if let loaded = try? decoder.decode(ProgressSnapshot.self, from: data) {
                self.snapshot = loaded
            }
        }
    }

    private func save() {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        if let data = try? encoder.encode(snapshot) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    // MARK: - Completion

    func isCompleted(_ topic: Topic) -> Bool {
        snapshot.completedTopicIds.contains(topic.id)
    }

    func toggleCompleted(_ topic: Topic) {
        if snapshot.completedTopicIds.contains(topic.id) {
            snapshot.completedTopicIds.remove(topic.id)
        } else {
            snapshot.completedTopicIds.insert(topic.id)
        }
        save()
    }

    var completedCount: Int {
        snapshot.completedTopicIds.count
    }

    // MARK: - Bookmarks

    func isBookmarked(_ topic: Topic) -> Bool {
        snapshot.bookmarkedTopicIds.contains(topic.id)
    }

    func toggleBookmark(_ topic: Topic) {
        if snapshot.bookmarkedTopicIds.contains(topic.id) {
            snapshot.bookmarkedTopicIds.remove(topic.id)
        } else {
            snapshot.bookmarkedTopicIds.insert(topic.id)
        }
        save()
    }

    var bookmarkedCount: Int {
        snapshot.bookmarkedTopicIds.count
    }

    // MARK: - Quiz Scoring

    func saveQuizScore(_ score: Int, for topic: Topic) {
        snapshot.quizScores[topic.id] = score
        save()
    }

    func bestQuizScore(for topic: Topic) -> Int {
        snapshot.quizScores[topic.id] ?? 0
    }

    // MARK: - Notes

    func saveNote(_ text: String, for topic: Topic) {
        snapshot.notes[topic.id] = text.isEmpty ? nil : text
        save()
    }

    func note(for topic: Topic) -> String {
        snapshot.notes[topic.id] ?? ""
    }

    // MARK: - Diagnostic

    func saveDiagnostic(scores: [String: Int]) {
        snapshot.diagnosticScores = scores
        save()
    }

    func diagnosticScore(for domain: Domain) -> Int {
        snapshot.diagnosticScores[domain.id] ?? 0
    }

    var hasDiagnostic: Bool {
        !snapshot.diagnosticScores.isEmpty
    }

    func readinessLabel(for domain: Domain) -> String {
        let score = diagnosticScore(for: domain)
        if score >= 75 { return "Ready" }
        if score >= 45 { return "Developing" }
        return "Emerging"
    }

    // MARK: - Scenarios

    func saveScenarioAttempt(scenario: Scenario, action: ScenarioAction, rationale: String) {
        let attempt = ScenarioAttempt(
            id: UUID(),
            scenarioId: scenario.id,
            actionId: action.id,
            score: action.score,
            rationale: rationale,
            createdAt: Date()
        )
        snapshot.scenarioAttempts.append(attempt)
        save()
    }

    var scenarioCount: Int {
        snapshot.scenarioAttempts.count
    }

    // MARK: - Study Sessions

    func recordStudySession(minutes: Int, for topic: Topic) {
        let session = StudySession(
            id: UUID(),
            topicId: topic.id,
            plannedMinutes: minutes,
            completedAt: Date()
        )
        snapshot.studySessions.append(session)
        save()
    }

    var studySessionCount: Int {
        snapshot.studySessions.count
    }

    // MARK: - Visited Topics

    func markVisited(_ topic: Topic) {
        snapshot.lastVisitedTopicId = topic.id
        save()
    }

    var lastVisitedTopic: Topic? {
        guard let id = snapshot.lastVisitedTopicId else { return nil }
        return CyberPathData.domains
            .flatMap(\.topics)
            .first(where: { $0.id == id })
    }

    // MARK: - Completion Metrics

    func completionPercent(for domain: Domain) -> Int {
        guard !domain.topics.isEmpty else { return 0 }
        let completed = domain.topics.filter { isCompleted($0) }.count
        return Int(Double(completed) / Double(domain.topics.count) * 100)
    }

    func totalCompletionPercent() -> Int {
        let allTopics = CyberPathData.domains.flatMap(\.topics)
        guard !allTopics.isEmpty else { return 0 }
        let completed = allTopics.filter { isCompleted($0) }.count
        return Int(Double(completed) / Double(allTopics.count) * 100)
    }

    // MARK: - Recommendations

    func recommendedNext() -> (Domain, Topic, String)? {
        for domain in CyberPathData.domains {
            for topic in domain.topics {
                if !isCompleted(topic) {
                    let reason = "Start with \(domain.title) fundamentals"
                    return (domain, topic, reason)
                }
            }
        }
        return nil
    }

    // MARK: - Export & Import

    func exportJSON() -> String {
        let export = ProgressExport(version: 1, exportedAt: Date(), snapshot: snapshot)
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(export),
              let json = String(data: data, encoding: .utf8) else {
            return "{}"
        }
        return json
    }

    func importJSON(_ json: String) -> Result<String, String> {
        guard let data = json.data(using: .utf8) else {
            return .failure("Import text is not valid UTF-8.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let importedExport = try decoder.decode(ProgressExport.self, from: data)
            snapshot = importedExport.snapshot
            save()
            return .success("Imported \(snapshot.completedTopicIds.count) completed topics and \(snapshot.scenarioAttempts.count) scenario attempts.")
        } catch {
            return .failure("Failed to parse progress JSON: \(error.localizedDescription)")
        }
    }

    // MARK: - Reset

    func reset() {
        snapshot = ProgressSnapshot()
        UserDefaults.standard.removeObject(forKey: storageKey)
    }
}
