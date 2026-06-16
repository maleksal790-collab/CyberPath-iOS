import Foundation
import Observation

@MainActor
@Observable
final class ProgressStore {
    private let exportVersion = 1
    private let storageKey = "cyberpath-ios-progress-v1"
    private(set) var snapshot: ProgressSnapshot

    init() {
        if let data = UserDefaults.standard.data(forKey: storageKey),
           let decoded = try? JSONDecoder().decode(ProgressSnapshot.self, from: data) {
            snapshot = decoded
        } else {
            snapshot = ProgressSnapshot()
        }
    }

    var completedCount: Int { snapshot.completedTopicIds.count }
    var bookmarkedCount: Int { snapshot.bookmarkedTopicIds.count }
    var scenarioCount: Int { snapshot.scenarioAttempts.count }
    var studySessionCount: Int { snapshot.studySessions.count }
    var hasDiagnostic: Bool { !snapshot.diagnosticScores.isEmpty }

    func domainAndTopic(for topicId: String?) -> (Domain, Topic)? {
        guard let topicId else { return nil }
        for domain in CyberPathData.domains {
            if let topic = domain.topics.first(where: { $0.id == topicId }) {
                return (domain, topic)
            }
        }
        return nil
    }

    func recommendedNext() -> (Domain, Topic, String)? {
        if let last = domainAndTopic(for: snapshot.lastVisitedTopicId), !isCompleted(last.1) {
            return (last.0, last.1, "Continue the topic you opened most recently.")
        }

        if let weakDomain = CyberPathData.domains
            .filter({ diagnosticScore(for: $0) > 0 && diagnosticScore(for: $0) < 75 })
            .sorted(by: { diagnosticScore(for: $0) < diagnosticScore(for: $1) })
            .first,
           let topic = weakDomain.topics.first(where: { !isCompleted($0) }) {
            return (weakDomain, topic, "This domain is still developing in your diagnostic results.")
        }

        for domain in CyberPathData.domains {
            if let topic = domain.topics.first(where: { !isCompleted($0) }) {
                return (domain, topic, "Next incomplete topic in the guided pathway.")
            }
        }

        return nil
    }

    func isCompleted(_ topic: Topic) -> Bool {
        snapshot.completedTopicIds.contains(topic.id)
    }

    func isBookmarked(_ topic: Topic) -> Bool {
        snapshot.bookmarkedTopicIds.contains(topic.id)
    }

    func bestQuizScore(for topic: Topic) -> Int {
        snapshot.quizScores[topic.id, default: 0]
    }

    func note(for topic: Topic) -> String {
        snapshot.notes[topic.id, default: ""]
    }

    func diagnosticScore(for domain: Domain) -> Int {
        snapshot.diagnosticScores[domain.id, default: 0]
    }

    func readinessLabel(for domain: Domain) -> String {
        let score = diagnosticScore(for: domain)
        if score >= 75 { return "Ready" }
        if score >= 45 { return "Developing" }
        return "Emerging"
    }

    func completionPercent(for domain: Domain) -> Int {
        guard !domain.topics.isEmpty else { return 0 }
        let completed = domain.topics.filter { isCompleted($0) }.count
        return Int((Double(completed) / Double(domain.topics.count) * 100).rounded())
    }

    func totalCompletionPercent(domains: [Domain] = CyberPathData.domains) -> Int {
        let topics = domains.flatMap(\.topics)
        guard !topics.isEmpty else { return 0 }
        let completed = topics.filter { isCompleted($0) }.count
        return Int((Double(completed) / Double(topics.count) * 100).rounded())
    }

    func toggleCompleted(_ topic: Topic) {
        if snapshot.completedTopicIds.contains(topic.id) {
            snapshot.completedTopicIds.remove(topic.id)
        } else {
            snapshot.completedTopicIds.insert(topic.id)
        }
        persist()
    }

    func toggleBookmark(_ topic: Topic) {
        if snapshot.bookmarkedTopicIds.contains(topic.id) {
            snapshot.bookmarkedTopicIds.remove(topic.id)
        } else {
            snapshot.bookmarkedTopicIds.insert(topic.id)
        }
        persist()
    }

    func saveQuizScore(_ score: Int, for topic: Topic) {
        snapshot.quizScores[topic.id] = max(score, snapshot.quizScores[topic.id, default: 0])
        persist()
    }

    func saveNote(_ text: String, for topic: Topic) {
        snapshot.notes[topic.id] = text
        persist()
    }

    func markVisited(_ topic: Topic) {
        snapshot.lastVisitedTopicId = topic.id
        persist()
    }

    func recordStudySession(minutes: Int, for topic: Topic) {
        snapshot.studySessions.insert(
            StudySession(id: UUID(), topicId: topic.id, plannedMinutes: minutes, completedAt: Date()),
            at: 0
        )
        persist()
    }

    func saveDiagnostic(scores: [String: Int]) {
        snapshot.diagnosticScores = scores
        persist()
    }

    func saveScenarioAttempt(scenario: Scenario, action: ScenarioAction, rationale: String) {
        snapshot.scenarioAttempts.insert(
            ScenarioAttempt(
                id: UUID(),
                scenarioId: scenario.id,
                actionId: action.id,
                score: action.score,
                rationale: rationale,
                createdAt: Date()
            ),
            at: 0
        )
        persist()
    }

    func reset() {
        snapshot = ProgressSnapshot()
        persist()
    }

    func exportJSON() -> String {
        let export = ProgressExport(version: exportVersion, exportedAt: Date(), snapshot: snapshot)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601
        guard let data = try? encoder.encode(export) else { return "{}" }
        return String(data: data, encoding: .utf8) ?? "{}"
    }

    func importJSON(_ json: String) -> Result<String, String> {
        guard let data = json.data(using: .utf8) else {
            return .failure("Import text is not valid UTF-8.")
        }

        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601

        do {
            let imported = try decoder.decode(ProgressExport.self, from: data)
            guard imported.version == exportVersion else {
                return .failure("Unsupported CyberPath iOS progress version.")
            }
            let sanitized = sanitize(imported.snapshot)
            snapshot = sanitized
            persist()
            return .success("Progress imported successfully.")
        } catch {
            return .failure("The selected text is not valid CyberPath iOS progress JSON.")
        }
    }

    private func persist() {
        if let data = try? JSONEncoder().encode(snapshot) {
            UserDefaults.standard.set(data, forKey: storageKey)
        }
    }

    private func sanitize(_ imported: ProgressSnapshot) -> ProgressSnapshot {
        let topicIds = Set(CyberPathData.domains.flatMap(\.topics).map(\.id))
        let domainIds = Set(CyberPathData.domains.map(\.id))
        
        let validScenarioIds = Set(CyberPathData.scenarios.map(\.id))
        let validActionIds = Set(CyberPathData.scenarios.flatMap(\.actions).map(\.id))

        return ProgressSnapshot(
            completedTopicIds: imported.completedTopicIds.intersection(topicIds),
            bookmarkedTopicIds: imported.bookmarkedTopicIds.intersection(topicIds),
            quizScores: imported.quizScores.filter { topicIds.contains($0.key) }.mapValues { min(100, max(0, $0)) },
            notes: imported.notes.filter { topicIds.contains($0.key) },
            diagnosticScores: imported.diagnosticScores.filter { domainIds.contains($0.key) }.mapValues { min(100, max(0, $0)) },
            scenarioAttempts: imported.scenarioAttempts.filter { attempt in
                validScenarioIds.contains(attempt.scenarioId) && validActionIds.contains(attempt.actionId)
            },
            lastVisitedTopicId: topicIds.contains(imported.lastVisitedTopicId ?? "") ? imported.lastVisitedTopicId : nil,
            studySessions: imported.studySessions.filter { topicIds.contains($0.topicId) }
        )
    }
}