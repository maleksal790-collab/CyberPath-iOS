import SwiftUI

struct ContentView: View {
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

struct DashboardView: View {
    @Environment(ProgressStore.self) private var progress

    private var recommended: (Domain, Topic, String)? {
        progress.recommendedNext()
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if let recommended {
                    NavigationLink(value: recommended.1) {
                        HeroCard(
                            eyebrow: "Recommended next",
                            title: recommended.1.title,
                            subtitle: "\(recommended.0.title) · \(recommended.1.minutes) min\nWhy this next? \(recommended.2)",
                            systemImage: "sparkles"
                        )
                    }
                    .buttonStyle(.plain)
                } else {
                    HeroCard(
                        eyebrow: "Recommended next",
                        title: "All guided topics complete",
                        subtitle: "Review scenario evidence, capstones, and your evidence report.",
                        systemImage: "sparkles"
                    )
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Today's focus plan")
                        .font(.headline)
                    NavigationLink {
                        DiagnosticView()
                    } label: {
                        FocusPlanCard(
                            title: progress.hasDiagnostic ? "Review diagnostic" : "Start diagnostic",
                            detail: "Answer 18 cross-domain questions and classify each area as Emerging, Developing, or Ready.",
                            symbol: "brain.head.profile"
                        )
                    }
                    .buttonStyle(.plain)
                    if let recommended {
                        NavigationLink(value: recommended.1) {
                            FocusPlanCard(title: "Resume", detail: recommended.1.overview, symbol: "arrow.forward.circle.fill")
                        }
                        .buttonStyle(.plain)
                    }
                    FocusPlanCard(title: "Learn", detail: "Use the domain library for concept refreshers, key terms, and quizzes.", symbol: "book.fill")
                    FocusPlanCard(title: "Practice", detail: "Run the credential-compromise scenario and save a decision brief.", symbol: "shield.lefthalf.filled")
                }

                LazyVGrid(columns: [.init(.flexible()), .init(.flexible())], spacing: 12) {
                    MetricCard(value: "\(progress.totalCompletionPercent())%", label: "Overall")
                    MetricCard(value: "\(progress.completedCount)", label: "Topics")
                    MetricCard(value: "\(progress.bookmarkedCount)", label: "Saved")
                    MetricCard(value: "\(progress.scenarioCount)", label: "Scenarios")
                    MetricCard(value: "\(progress.studySessionCount)", label: "Sessions")
                }

                VStack(alignment: .leading, spacing: 12) {
                    Text("Learning domains")
                        .font(.headline)
                    ForEach(CyberPathData.domains) { domain in
                        NavigationLink(value: domain) {
                            DomainRow(domain: domain)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle("CyberPath")
        .navigationDestination(for: Domain.self) { domain in
            DomainDetailView(domain: domain)
        }
        .navigationDestination(for: Topic.self) { topic in
            if let domain = CyberPathData.domains.first(where: { $0.topics.contains(topic) }) {
                TopicDetailView(domain: domain, topic: topic)
            }
        }
    }
}

struct DomainsView: View {
    @State private var query = ""
    @State private var selectedStage = "All"

    private var stages: [String] {
        ["All"] + Array(Set(CyberPathData.domains.map(\.stage))).sorted()
    }

    private var filteredDomains: [Domain] {
        CyberPathData.domains.filter { domain in
            let matchesStage = selectedStage == "All" || domain.stage == selectedStage
            let text = "\(domain.title) \(domain.summary) \(domain.topics.map(\.title).joined(separator: " "))"
            let matchesQuery = query.isEmpty || text.localizedCaseInsensitiveContains(query)
            return matchesStage && matchesQuery
        }
    }

    var body: some View {
        List {
            Section {
                Picker("Stage", selection: $selectedStage) {
                    ForEach(stages, id: \.self) { Text($0) }
                }
                .pickerStyle(.segmented)
            }

            Section("Domains") {
                ForEach(filteredDomains) { domain in
                    NavigationLink(value: domain) {
                        DomainRow(domain: domain)
                    }
                }
            }
        }
        .searchable(text: $query, prompt: "Search learning materials")
        .navigationTitle("Learning")
        .navigationDestination(for: Domain.self) { domain in
            DomainDetailView(domain: domain)
        }
    }
}

struct DomainDetailView: View {
    @Environment(ProgressStore.self) private var progress
    let domain: Domain

    var body: some View {
        List {
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    Label(domain.stage, systemImage: domain.symbol)
                        .foregroundStyle(domain.color)
                    Text(domain.summary)
                        .foregroundStyle(.secondary)
                    ProgressView(value: Double(progress.completionPercent(for: domain)), total: 100)
                        .tint(domain.color)
                    Text("\(progress.completionPercent(for: domain))% complete")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                .padding(.vertical, 4)
            } header: {
                Text("Study path summary")
            }

            Section("Topics") {
                ForEach(domain.topics) { topic in
                    NavigationLink(value: topic) {
                        TopicRow(topic: topic, score: progress.bestQuizScore(for: topic), completed: progress.isCompleted(topic))
                    }
                }
            }

            Section("Applied capstone") {
                Text(domain.capstone)
            }
        }
        .navigationTitle(domain.title)
        .navigationDestination(for: Topic.self) { topic in
            TopicDetailView(domain: domain, topic: topic)
        }
    }
}

struct TopicDetailView: View {
    @Environment(ProgressStore.self) private var progress
    let domain: Domain
    let topic: Topic
    @State private var selectedQuizIndex = 0
    @State private var selectedAnswers: [Int: Int] = [:]
    @State private var noteDraft = ""
    @State private var sessionNotice: String?

    private var currentQuiz: QuizQuestion {
        topic.quizzes[selectedQuizIndex]
    }

    private var currentSelectedAnswer: Int? {
        selectedAnswers[selectedQuizIndex]
    }

    private var answeredQuizCount: Int {
        selectedAnswers.keys.filter { topic.quizzes.indices.contains($0) }.count
    }

    private var correctQuizCount: Int {
        selectedAnswers.reduce(0) { total, answer in
            guard topic.quizzes.indices.contains(answer.key) else { return total }
            return total + (topic.quizzes[answer.key].correctIndex == answer.value ? 1 : 0)
        }
    }

    var body: some View {
        List {
            Section("Brief") {
                Text(topic.overview)
                Text(topic.workplaceUse)
                    .foregroundStyle(.secondary)
            }

            Section("Key terms") {
                FlowTags(values: topic.keyTerms)
            }

            Section("Actions") {
                Button(progress.isCompleted(topic) ? "Mark incomplete" : "Mark complete") {
                    progress.toggleCompleted(topic)
                }
                Button(progress.isBookmarked(topic) ? "Remove bookmark" : "Bookmark") {
                    progress.toggleBookmark(topic)
                }
            }

            Section("Study session") {
                Text("Log a focused study block after reviewing this topic. This supports weekly activity without streak pressure.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                HStack {
                    Button("15 min") {
                        progress.recordStudySession(minutes: 15, for: topic)
                        sessionNotice = "15-minute session saved."
                    }
                    Button("25 min") {
                        progress.recordStudySession(minutes: 25, for: topic)
                        sessionNotice = "25-minute session saved."
                    }
                    Button("45 min") {
                        progress.recordStudySession(minutes: 45, for: topic)
                        sessionNotice = "45-minute session saved."
                    }
                }
                if let sessionNotice {
                    Label(sessionNotice, systemImage: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }

            Section("Quiz") {
                if topic.quizzes.count > 1 {
                    Picker("Question", selection: $selectedQuizIndex) {
                        ForEach(topic.quizzes.indices, id: \.self) { index in
                            Text("Question \(index + 1)").tag(index)
                        }
                    }
                    .pickerStyle(.menu)

                    Text("\(answeredQuizCount) of \(topic.quizzes.count) answered · \(correctQuizCount) correct")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Text(currentQuiz.question)
                    .font(.headline)
                ForEach(currentQuiz.answers.indices, id: \.self) { index in
                    Button {
                        let updatedAnswers = selectedAnswers.merging([selectedQuizIndex: index]) { _, new in new }
                        selectedAnswers = updatedAnswers
                        progress.saveQuizScore(scorePercent(from: updatedAnswers), for: topic)
                    } label: {
                        HStack {
                            Text(currentQuiz.answers[index])
                            Spacer()
                            if currentSelectedAnswer == index {
                                Image(systemName: index == currentQuiz.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    .foregroundStyle(index == currentQuiz.correctIndex ? .green : .red)
                            }
                        }
                    }
                }
                if currentSelectedAnswer != nil {
                    Text(currentQuiz.explanation)
                        .font(.callout)
                        .foregroundStyle(.secondary)
                }
            }

            Section("Learner notes") {
                TextEditor(text: $noteDraft)
                    .frame(minHeight: 140)
                    .onChange(of: noteDraft) { _, newValue in
                        progress.saveNote(newValue, for: topic)
                    }
            }
        }
        .navigationTitle(topic.title)
        .onAppear {
            progress.markVisited(topic)
            noteDraft = progress.note(for: topic)
        }
    }

    private func scorePercent(from answers: [Int: Int]) -> Int {
        guard !topic.quizzes.isEmpty else { return 0 }
        let correctAnswers = answers.reduce(0) { total, answer in
            guard topic.quizzes.indices.contains(answer.key) else { return total }
            return total + (topic.quizzes[answer.key].correctIndex == answer.value ? 1 : 0)
        }
        return Int(Double(correctAnswers) / Double(topic.quizzes.count) * 100)
    }
}

struct ScenarioListView: View {
    var body: some View {
        List(CyberPathData.scenarios) { scenario in
            NavigationLink(value: scenario) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(scenario.title)
                        .font(.headline)
                    Text(scenario.summary)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }
                .padding(.vertical, 4)
            }
        }
        .navigationTitle("Practice Labs")
        .navigationDestination(for: Scenario.self) { scenario in
            ScenarioLabView(scenario: scenario)
        }
    }
}

struct ScenarioLabView: View {
    @Environment(ProgressStore.self) private var progress
    let scenario: Scenario
    @State private var selectedEvidence = Set<String>()
    @State private var selectedAction: ScenarioAction?
    @State private var selectedFollowUp: FollowUpAction?
    @State private var confidence = 60.0
    @State private var rationale = ""
    @State private var saved = false

    private var decisionBrief: [String] {
        [
            "Evidence reviewed: \(selectedEvidence.isEmpty ? "none selected" : selectedEvidence.sorted().joined(separator: ", ")).",
            "Initial action: \(selectedAction?.label ?? "not selected yet").",
            "Follow-up: \(selectedFollowUp?.label ?? "pending reassessment").",
            "Confidence: \(Int(confidence))%.",
            rationale.isEmpty ? "Rationale: add business impact, evidence basis, and verification step." : "Rationale: \(rationale)"
        ]
    }

    var body: some View {
        List {
            Section {
                Text(scenario.summary)
                Text("High severity")
                    .font(.caption)
                    .foregroundStyle(.red)
            } header: {
                Text(scenario.title)
            }

            Section("Inspect evidence") {
                ForEach(scenario.evidence) { item in
                    Toggle(isOn: Binding(
                        get: { selectedEvidence.contains(item.title) },
                        set: { isOn in
                            if isOn { selectedEvidence.insert(item.title) } else { selectedEvidence.remove(item.title) }
                        }
                    )) {
                        VStack(alignment: .leading) {
                            Text(item.title)
                            Text(item.detail)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Choose your first coordinated action") {
                ForEach(scenario.actions) { action in
                    Button {
                        selectedAction = action
                        selectedFollowUp = nil
                        saved = false
                    } label: {
                        VStack(alignment: .leading, spacing: 6) {
                            Text(action.label)
                            if selectedAction?.id == action.id {
                                Text("\(action.score)% · \(action.feedback)")
                                    .font(.caption)
                                    .foregroundStyle(action.score >= 80 ? .green : .orange)
                            }
                        }
                    }
                }
            }

            if let action = selectedAction {
                Section("Branch 2: the situation changes") {
                    Text(action.development)
                    ForEach(action.followUps) { followUp in
                        Button {
                            selectedFollowUp = followUp
                            saved = false
                        } label: {
                            VStack(alignment: .leading, spacing: 6) {
                                Text(followUp.label)
                                if selectedFollowUp?.id == followUp.id {
                                    Text(followUp.recommended ? "Recommended follow-up" : "Tradeoff to reconsider")
                                        .font(.caption)
                                        .foregroundStyle(followUp.recommended ? .green : .orange)
                                    Text(followUp.consequence)
                                        .font(.caption)
                                        .foregroundStyle(.secondary)
                                }
                            }
                        }
                    }
                }
            }

            Section("Confidence and rationale") {
                Slider(value: $confidence, in: 0...100, step: 5) {
                    Text("Decision confidence")
                }
                Text("\(Int(confidence))% confidence")
                    .font(.caption)
                TextEditor(text: $rationale)
                    .frame(minHeight: 140)
            }

            Section("Generated decision brief") {
                ForEach(decisionBrief, id: \.self) { line in
                    Text(line)
                        .font(.callout)
                }
            }

            Section {
                Button(saved ? "Evidence saved" : "Save scenario evidence") {
                    guard let selectedAction else { return }
                    progress.saveScenarioAttempt(scenario: scenario, action: selectedAction, rationale: rationale)
                    saved = true
                }
                .disabled(selectedAction == nil || rationale.count < 20 || saved)
            }
        }
        .navigationTitle("Scenario lab")
    }
}

struct VisualStudioView: View {
    @State private var selectedLesson = CyberPathData.visualLessons[0]
    @State private var likelihood = 4.0
    @State private var impact = 5.0
    @State private var selectedThreat = "Spoofing"

    var body: some View {
        List {
            Section("Interactive visual studio") {
                Picker("Visual", selection: $selectedLesson) {
                    ForEach(CyberPathData.visualLessons) { lesson in
                        Text(lesson.title).tag(lesson)
                    }
                }
                Text(selectedLesson.summary)
                    .foregroundStyle(.secondary)
            }

            if selectedLesson.id == "risk" {
                Section("Risk treatment") {
                    Slider(value: $likelihood, in: 1...5, step: 1) { Text("Likelihood") }
                    Slider(value: $impact, in: 1...5, step: 1) { Text("Impact") }
                    let score = Int(likelihood * impact)
                    MetricCard(value: "\(score)", label: score >= 20 ? "Critical inherent risk" : "Inherent risk")
                    Text("Mitigate when added controls can reduce likelihood or impact. Accept only with accountable approval and review.")
                        .foregroundStyle(.secondary)
                }
            }

            if selectedLesson.id == "threat" {
                Section("Threat model canvas") {
                    Picker("Threat", selection: $selectedThreat) {
                        Text("Spoofing").tag("Spoofing")
                        Text("Tampering").tag("Tampering")
                        Text("Information disclosure").tag("Information disclosure")
                        Text("Denial of service").tag("Denial of service")
                    }
                    .pickerStyle(.segmented)
                    CanvasRow(label: "Asset", value: "Customer profile and billing data")
                    CanvasRow(label: "Entry point", value: "Login, profile API, export endpoint")
                    CanvasRow(label: "Mitigation", value: mitigation(for: selectedThreat))
                }
            }

            Section("Learning prompts") {
                ForEach(selectedLesson.prompts, id: \.self) { prompt in
                    Label(prompt, systemImage: "checkmark.seal")
                }
            }
        }
        .navigationTitle("Visuals")
    }

    private func mitigation(for threat: String) -> String {
        switch threat {
        case "Tampering":
            "Use integrity checks, authorization checks, immutable logs, and protected deployment paths."
        case "Information disclosure":
            "Minimize data, classify fields, encrypt sensitive records, and test object-level authorization."
        case "Denial of service":
            "Apply quotas, rate limits, queue isolation, graceful degradation, and operational alerts."
        default:
            "Require phishing-resistant authentication, token validation, and device posture checks."
        }
    }
}

struct ProgressDashboardView: View {
    @Environment(ProgressStore.self) private var progress
    @State private var confirmReset = false

    var body: some View {
        List {
            Section("Journey snapshot") {
                MetricCard(value: "\(progress.totalCompletionPercent())%", label: "Overall completion")
                MetricCard(value: "\(progress.completedCount)", label: "Completed topics")
                MetricCard(value: "\(progress.bookmarkedCount)", label: "Bookmarks")
                MetricCard(value: "\(progress.scenarioCount)", label: "Scenario attempts")
                MetricCard(value: "\(progress.studySessionCount)", label: "Study sessions")
            }

            Section("Readiness") {
                NavigationLink {
                    DiagnosticView()
                } label: {
                    Label(progress.hasDiagnostic ? "Review diagnostic results" : "Start diagnostic", systemImage: "brain.head.profile")
                }
                NavigationLink {
                    EvidenceReportView()
                } label: {
                    Label("Open evidence report", systemImage: "doc.text.magnifyingglass")
                }
            }

            Section("Recent scenario evidence") {
                if progress.snapshot.scenarioAttempts.isEmpty {
                    Text("No scenario evidence saved yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(progress.snapshot.scenarioAttempts.prefix(5)) { attempt in
                        VStack(alignment: .leading) {
                            Text("\(attempt.score)% scenario decision")
                                .font(.headline)
                            Text(attempt.rationale)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }

            Section("Local data") {
                NavigationLink {
                    ProgressDataView()
                } label: {
                    Label("Export / import progress", systemImage: "square.and.arrow.up.on.square")
                }
                Button("Reset local progress", role: .destructive) {
                    confirmReset = true
                }
            }
        }
        .navigationTitle("Progress")
        .confirmationDialog("Reset all local CyberPath progress?", isPresented: $confirmReset) {
            Button("Reset progress", role: .destructive) {
                progress.reset()
            }
        }
    }
}

struct ProgressDataView: View {
    @Environment(ProgressStore.self) private var progress
    @State private var exportText = ""
    @State private var importText = ""
    @State private var notice: String?
    @State private var importFailed = false

    var body: some View {
        List {
            Section("Export") {
                Text("This JSON includes local completions, bookmarks, quiz scores, notes, diagnostic scores, and scenario evidence.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                TextEditor(text: $exportText)
                    .font(.system(.caption, design: .monospaced))
                    .frame(minHeight: 180)
                    .textSelection(.enabled)
                ShareLink(item: exportText) {
                    Label("Share progress JSON", systemImage: "square.and.arrow.up")
                }
                Button("Refresh export") {
                    exportText = progress.exportJSON()
                }
            }

            Section("Import") {
                Text("Paste a CyberPath iOS progress export. Unknown topics, domains, or scenario actions are ignored.")
                    .font(.callout)
                    .foregroundStyle(.secondary)
                TextEditor(text: $importText)
                    .font(.system(.caption, design: .monospaced))
                    .frame(minHeight: 180)
                Button("Import pasted progress") {
                    switch progress.importJSON(importText) {
                    case .success(let message):
                        notice = message
                        importFailed = false
                        exportText = progress.exportJSON()
                    case .failure(let message):
                        notice = message
                        importFailed = true
                    }
                }
                .disabled(importText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }

            if let notice {
                Section("Status") {
                    Label(notice, systemImage: importFailed ? "exclamationmark.triangle.fill" : "checkmark.circle.fill")
                        .foregroundStyle(importFailed ? .orange : .green)
                }
            }
        }
        .navigationTitle("Progress data")
        .onAppear {
            exportText = progress.exportJSON()
        }
    }
}

struct DiagnosticView: View {
    @Environment(ProgressStore.self) private var progress
    @State private var answers: [String: Int] = [:]

    private var answeredCount: Int {
        answers.values.filter { $0 >= 0 }.count
    }

    private var scores: [String: Int] {
        var totals: [String: (sum: Int, count: Int)] = [:]
        for question in CyberPathData.diagnosticQuestions {
            guard let score = answers[question.id] else { continue }
            guard score >= 0 else { continue }
            let current = totals[question.domainId, default: (0, 0)]
            totals[question.domainId] = (current.sum + score, current.count + 1)
        }
        return totals.mapValues { value in
            guard value.count > 0 else { return 0 }
            return Int((Double(value.sum) / Double(value.count)).rounded())
        }
    }

    var body: some View {
        List {
            Section {
                Text("\(answeredCount)/\(CyberPathData.diagnosticQuestions.count) answered")
                    .font(.headline)
                ProgressView(value: Double(answeredCount), total: Double(CyberPathData.diagnosticQuestions.count))
            } header: {
                Text("Cross-domain diagnostic")
            } footer: {
                Text("Results stay local on this device and inform readiness labels.")
            }

            Section("Questions") {
                ForEach(CyberPathData.diagnosticQuestions) { question in
                    VStack(alignment: .leading, spacing: 8) {
                        Text(question.prompt)
                            .font(.headline)
                        Picker("Answer", selection: Binding(
                            get: { answers[question.id, default: -1] },
                            set: { value in
                                if value >= 0 {
                                    answers[question.id] = value
                                } else {
                                    answers.removeValue(forKey: question.id)
                                }
                            }
                        )) {
                            Text("Choose").tag(-1)
                            ForEach(question.answers) { answer in
                                Text(answer.label).tag(answer.score)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                    .padding(.vertical, 4)
                }
            }

            if !scores.isEmpty {
                Section("Current readiness") {
                    ForEach(CyberPathData.domains) { domain in
                        let score = scores[domain.id, default: progress.diagnosticScore(for: domain)]
                        HStack {
                            VStack(alignment: .leading) {
                                Text(domain.title)
                                Text(label(for: score))
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                            }
                            Spacer()
                            Text("\(score)%")
                                .font(.headline)
                        }
                    }
                }
            }

            Section {
                Button("Save diagnostic results") {
                    progress.saveDiagnostic(scores: scores)
                }
                .disabled(answeredCount != CyberPathData.diagnosticQuestions.count)
            }
        }
        .navigationTitle("Diagnostic")
    }

    private func label(for score: Int) -> String {
        if score >= 75 { return "Ready" }
        if score >= 45 { return "Developing" }
        return "Emerging"
    }
}

struct EvidenceReportView: View {
    @Environment(ProgressStore.self) private var progress

    var body: some View {
        List {
            Section("Non-certification notice") {
                Text("This report summarizes local learning evidence only. It is not a formal certification or third-party credential.")
                    .foregroundStyle(.secondary)
            }

            Section("Learning evidence") {
                MetricCard(value: "\(progress.totalCompletionPercent())%", label: "Overall completion")
                MetricCard(value: "\(progress.completedCount)", label: "Completed topics")
                MetricCard(value: "\(progress.scenarioCount)", label: "Scenario decisions")
            }

            Section("Domain readiness") {
                ForEach(CyberPathData.domains) { domain in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(domain.title)
                            Text(progress.readinessLabel(for: domain))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                        Spacer()
                        Text("\(progress.diagnosticScore(for: domain))%")
                            .font(.headline)
                    }
                }
            }

            Section("Recent scenario evidence") {
                if progress.snapshot.scenarioAttempts.isEmpty {
                    Text("No scenario evidence saved yet.")
                        .foregroundStyle(.secondary)
                } else {
                    ForEach(progress.snapshot.scenarioAttempts.prefix(5)) { attempt in
                        VStack(alignment: .leading, spacing: 4) {
                            Text("\(attempt.score)% decision")
                                .font(.headline)
                            Text(attempt.rationale)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Evidence report")
    }
}

struct HeroCard: View {
    let eyebrow: String
    let title: String
    let subtitle: String
    let systemImage: String

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Label(eyebrow, systemImage: systemImage)
                .font(.caption.weight(.bold))
                .textCase(.uppercase)
                .foregroundStyle(.cyan)
            Text(title)
                .font(.largeTitle.weight(.bold))
            Text(subtitle)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(22)
        .background(
            LinearGradient(colors: [Color.cyan.opacity(0.25), Color.blue.opacity(0.12)], startPoint: .topLeading, endPoint: .bottomTrailing),
            in: RoundedRectangle(cornerRadius: 28, style: .continuous)
        )
    }
}

struct FocusPlanCard: View {
    let title: String
    let detail: String
    let symbol: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: symbol)
                .foregroundStyle(.cyan)
                .font(.title2)
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                Text(detail)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct MetricCard: View {
    let value: String
    let label: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(value)
                .font(.title.weight(.bold))
            Text(label)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(.thinMaterial, in: RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}

struct DomainRow: View {
    @Environment(ProgressStore.self) private var progress
    let domain: Domain

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: domain.symbol)
                .foregroundStyle(domain.color)
                .frame(width: 34, height: 34)
                .background(domain.color.opacity(0.16), in: RoundedRectangle(cornerRadius: 10))
            VStack(alignment: .leading, spacing: 4) {
                Text(domain.title)
                    .font(.headline)
                Text(domain.summary)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                ProgressView(value: Double(progress.completionPercent(for: domain)), total: 100)
                    .tint(domain.color)
            }
            Text(domain.stage)
                .font(.caption2.weight(.bold))
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(.quaternary, in: Capsule())
        }
    }
}

struct TopicRow: View {
    let topic: Topic
    let score: Int
    let completed: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            HStack {
                Text(topic.title)
                    .font(.headline)
                Spacer()
                if completed {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
            Text("\(topic.minutes) min · difficulty \(topic.difficulty) · best quiz \(score)%")
                .font(.caption)
                .foregroundStyle(.secondary)
        }
    }
}

struct FlowTags: View {
    let values: [String]

    var body: some View {
        LazyVGrid(columns: [.init(.adaptive(minimum: 92), spacing: 8)], alignment: .leading, spacing: 8) {
            ForEach(values, id: \.self) { value in
                Text(value)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(.quaternary, in: Capsule())
            }
        }
    }
}

struct CanvasRow: View {
    let label: String
    let value: String

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.caption.weight(.bold))
                .foregroundStyle(.cyan)
            Text(value)
        }
    }
}

struct AppBackground: View {
    var body: some View {
        LinearGradient(colors: [Color(.systemBackground), Color.cyan.opacity(0.08)], startPoint: .top, endPoint: .bottom)
            .ignoresSafeArea()
    }
}

#Preview {
    ContentView()
        .environment(ProgressStore())
}