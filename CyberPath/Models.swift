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
    let deepDive: [String]
    let keyTerms: [String]
    let relatedTopicIds: [String]
    let quiz: QuizQuestion
    let quizzes: [QuizQuestion]

    init(
        id: String,
        title: String,
        minutes: Int,
        difficulty: Int,
        overview: String,
        workplaceUse: String,
        deepDive: [String] = [],
        keyTerms: [String],
        relatedTopicIds: [String] = [],
        quiz: QuizQuestion
    ) {
        self.id = id
        self.title = title
        self.minutes = minutes
        self.difficulty = difficulty
        self.overview = overview
        self.workplaceUse = workplaceUse
        self.deepDive = deepDive
        self.keyTerms = keyTerms
        self.relatedTopicIds = relatedTopicIds
        self.quiz = quiz
        self.quizzes = [quiz]
    }

    init(
        id: String,
        title: String,
        minutes: Int,
        difficulty: Int,
        overview: String,
        workplaceUse: String,
        deepDive: [String] = [],
        keyTerms: [String],
        relatedTopicIds: [String] = [],
        quizzes: [QuizQuestion]
    ) {
        let primaryQuiz = quizzes.first ?? QuizQuestion(
            question: "No quiz is available for this topic yet.",
            answers: ["Review the topic content first."],
            correctIndex: 0,
            explanation: "This placeholder protects the model from empty quiz arrays during staged content migration."
        )

        self.id = id
        self.title = title
        self.minutes = minutes
        self.difficulty = difficulty
        self.overview = overview
        self.workplaceUse = workplaceUse
        self.deepDive = deepDive
        self.keyTerms = keyTerms
        self.relatedTopicIds = relatedTopicIds
        self.quiz = primaryQuiz
        self.quizzes = quizzes.isEmpty ? [primaryQuiz] : quizzes
    }
}

struct QuizQuestion: Hashable {
    let question: String
    let answers: [String]
    let correctIndex: Int
    let explanation: String
}

struct GlossaryTerm: Identifiable, Hashable {
    let id: String
    let term: String
    let definition: String
    let relatedDomainIds: [String]

    init(term: String, definition: String, relatedDomainIds: [String] = []) {
        self.id = term
        self.term = term
        self.definition = definition
        self.relatedDomainIds = relatedDomainIds
    }
}

struct PortCheatSheetItem: Identifiable, Hashable {
    var id: String { "\(port)-\(transportProtocol)" }
    let port: Int
    let transportProtocol: String
    let usesTCP: Bool
    let description: String
}

struct FrameworkComparison: Identifiable, Hashable {
    let id: String
    let framework: String
    let scope: String
    let approach: String
    let structure: String
    let bestFor: String

    init(framework: String, scope: String, approach: String, structure: String, bestFor: String) {
        self.id = framework
        self.framework = framework
        self.scope = scope
        self.approach = approach
        self.structure = structure
        self.bestFor = bestFor
    }
}

struct SecurityMetric: Identifiable, Hashable {
    let id: String
    let metric: String
    let fullName: String
    let description: String
    let target: String
    let category: String

    init(metric: String, fullName: String, description: String, target: String, category: String) {
        self.id = metric
        self.metric = metric
        self.fullName = fullName
        self.description = description
        self.target = target
        self.category = category
    }
}

struct ToolLandscapeCategory: Identifiable, Hashable {
    let id: String
    let category: String
    let tools: [String]

    init(category: String, tools: [String]) {
        self.id = category
        self.category = category
        self.tools = tools
    }
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