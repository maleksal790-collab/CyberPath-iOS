# Multi-Quiz UI Patch Plan

Status: implementation was blocked by the tool safety layer before `ContentView.swift` could be updated directly.

Target branch: `feature/ios-multi-quiz-ui`

## Intended scope

- Update `TopicDetailView` to render `topic.quizzes` instead of the legacy single `topic.quiz`.
- Track selected answers per question.
- Reveal explanations per question.
- Save an aggregate quiz score using the existing `ProgressStore.saveQuizScore(_:for:)` API.
- Avoid content migration, Vercel changes, and UX redesign.

## Intended state variables

```swift
@State private var selectedAnswers: [Int: Int] = [:]
@State private var revealedQuestions = Set<Int>()
```

## Intended score calculation

```swift
private var answeredQuizCount: Int {
    selectedAnswers.count
}

private var quizScore: Int {
    guard !topic.quizzes.isEmpty else { return 0 }
    let correctCount = topic.quizzes.enumerated().filter { questionIndex, question in
        selectedAnswers[questionIndex] == question.correctIndex
    }.count
    return Int((Double(correctCount) / Double(topic.quizzes.count) * 100).rounded())
}
```

## Intended quiz rendering

```swift
Section("Quiz") {
    Text("\(answeredQuizCount)/\(topic.quizzes.count) answered")
        .font(.caption)
        .foregroundStyle(.secondary)
    ProgressView(value: Double(answeredQuizCount), total: Double(max(topic.quizzes.count, 1)))

    ForEach(Array(topic.quizzes.enumerated()), id: \.offset) { questionIndex, question in
        VStack(alignment: .leading, spacing: 10) {
            Text("Question \(questionIndex + 1)")
                .font(.caption.weight(.bold))
                .foregroundStyle(.secondary)
            Text(question.question)
                .font(.headline)

            ForEach(question.answers.indices, id: \.self) { answerIndex in
                Button {
                    selectedAnswers[questionIndex] = answerIndex
                    revealedQuestions.insert(questionIndex)
                    progress.saveQuizScore(quizScore, for: topic)
                } label: {
                    HStack {
                        Text(question.answers[answerIndex])
                        Spacer()
                        if selectedAnswers[questionIndex] == answerIndex {
                            Image(systemName: answerIndex == question.correctIndex ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundStyle(answerIndex == question.correctIndex ? .green : .red)
                        }
                    }
                }
            }

            if revealedQuestions.contains(questionIndex) {
                Text(question.explanation)
                    .font(.callout)
                    .foregroundStyle(.secondary)
            }
        }
        .padding(.vertical, 6)
    }

    if answeredQuizCount > 0 {
        Text("Current score: \(quizScore)%")
            .font(.callout.weight(.semibold))
    }
}
```

## Manual application target

Replace the existing single-question `Section("Quiz")` in `CyberPath/ContentView.swift` and replace the old `selectedAnswer` / `showExplanation` state with the new state above.