import Foundation
import SwiftUI

struct Domain: Identifiable, Hashable {
    let id: String
    let title: String
    let symbol: String
    let colorHex: String
    let summary: String
    let stage: String
    let topics: [Topic]
    let capstone: String

    var color: Color { Color(hex: colorHex) }
}

struct Topic: Identifiable, Hashable {
    let id: String
    let title: String
    let minutes: Int
    let difficulty: Int
    let overview: String
    let workplaceUse: String
    let keyTerms: [String]
    let quiz: QuizQuestion
}

struct QuizQuestion: Hashable {
    let question: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}

struct Scenario: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let evidence: [EvidenceItem]
    let actions: [ScenarioAction]
}

struct EvidenceItem: Identifiable, Hashable {
    var id: String { title }
    let title: String
    let detail: String
}

struct ScenarioAction: Identifiable, Hashable {
    let id: String
    let label: String
    let score: Int
    let feedback: String
    let development: String
    let followUps: [FollowUpAction]
}

struct FollowUpAction: Identifiable, Hashable {
    let id: String
    let label: String
    let consequence: String
    let recommended: Bool
}

struct VisualLesson: Identifiable, Hashable {
    let id: String
    let title: String
    let summary: String
    let prompts: [String]
}

struct DiagnosticQuestion: Identifiable, Hashable {
    let id: String
    let domainId: String
    let prompt: String
    let answers: [DiagnosticAnswer]
}

struct DiagnosticAnswer: Identifiable, Hashable {
    var id: String { label }
    let label: String
    let score: Int
}

struct ProgressSnapshot: Codable {
    var completedTopicIds: Set<String> = []
    var bookmarkedTopicIds: Set<String> = []
    var quizScores: [String: Int] = [:]
    var notes: [String: String] = [:]
    var diagnosticScores: [String: Int] = [:]
    var scenarioAttempts: [ScenarioAttempt] = []
    var lastVisitedTopicId: String?
    var studySessions: [StudySession] = []

    init(
        completedTopicIds: Set<String> = [],
        bookmarkedTopicIds: Set<String> = [],
        quizScores: [String: Int] = [:],
        notes: [String: String] = [:],
        diagnosticScores: [String: Int] = [:],
        scenarioAttempts: [ScenarioAttempt] = [],
        lastVisitedTopicId: String? = nil,
        studySessions: [StudySession] = []
    ) {
        self.completedTopicIds = completedTopicIds
        self.bookmarkedTopicIds = bookmarkedTopicIds
        self.quizScores = quizScores
        self.notes = notes
        self.diagnosticScores = diagnosticScores
        self.scenarioAttempts = scenarioAttempts
        self.lastVisitedTopicId = lastVisitedTopicId
        self.studySessions = studySessions
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        completedTopicIds = try container.decodeIfPresent(Set<String>.self, forKey: .completedTopicIds) ?? []
        bookmarkedTopicIds = try container.decodeIfPresent(Set<String>.self, forKey: .bookmarkedTopicIds) ?? []
        quizScores = try container.decodeIfPresent([String: Int].self, forKey: .quizScores) ?? [:]
        notes = try container.decodeIfPresent([String: String].self, forKey: .notes) ?? [:]
        diagnosticScores = try container.decodeIfPresent([String: Int].self, forKey: .diagnosticScores) ?? [:]
        scenarioAttempts = try container.decodeIfPresent([ScenarioAttempt].self, forKey: .scenarioAttempts) ?? []
        lastVisitedTopicId = try container.decodeIfPresent(String.self, forKey: .lastVisitedTopicId)
        studySessions = try container.decodeIfPresent([StudySession].self, forKey: .studySessions) ?? []
    }
}

struct ProgressExport: Codable {
    let version: Int
    let exportedAt: Date
    let snapshot: ProgressSnapshot
}

struct ScenarioAttempt: Codable, Identifiable, Hashable {
    let id: UUID
    let scenarioId: String
    let actionId: String
    let score: Int
    let rationale: String
    let createdAt: Date
}

struct StudySession: Codable, Identifiable, Hashable {
    let id: UUID
    let topicId: String
    let plannedMinutes: Int
    let completedAt: Date
}

extension Color {
    init(hex: String) {
        let normalized = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var integer: UInt64 = 0
        Scanner(string: normalized).scanHexInt64(&integer)
        let red = Double((integer >> 16) & 0xff) / 255
        let green = Double((integer >> 8) & 0xff) / 255
        let blue = Double(integer & 0xff) / 255
        self.init(red: red, green: green, blue: blue)
    }
}
