import { useState, useEffect } from "react";
import { ScrollView, Text, View, Pressable, TextInput } from "react-native";
import { useLocalSearchParams, useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { domains } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";
import type { QuizQuestion } from "@/lib/data";

export default function TopicDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const colors = useColors();
  const {
    state,
    completeTopic,
    uncompleteTopic,
    toggleBookmark,
    setQuizScore,
    setNote,
    setLastVisited,
    addStudySession,
  } = useProgress();

  const [activeSection, setActiveSection] = useState<"overview" | "deepdive" | "quiz" | "notes">("overview");
  const [quizIndex, setQuizIndex] = useState(0);
  const [selectedAnswer, setSelectedAnswer] = useState<number | null>(null);
  const [showExplanation, setShowExplanation] = useState(false);
  const [correctCount, setCorrectCount] = useState(0);
  const [quizComplete, setQuizComplete] = useState(false);
  const [noteText, setNoteText] = useState("");

  const topic = domains.flatMap((d) => d.topics).find((t) => t.id === id);
  const domain = domains.find((d) => d.topics.some((t) => t.id === id));

  useEffect(() => {
    if (id) {
      setLastVisited(id);
      addStudySession(id, topic?.minutes || 5);
    }
  }, [id]);

  useEffect(() => {
    if (id && state.notes[id]) {
      setNoteText(state.notes[id]);
    }
  }, [id, state.notes]);

  if (!topic || !domain) {
    return (
      <ScreenContainer className="items-center justify-center">
        <Text className="text-foreground">Topic not found</Text>
      </ScreenContainer>
    );
  }

  const isCompleted = state.completedTopicIds.includes(topic.id);
  const isBookmarked = state.bookmarkedTopicIds.includes(topic.id);
  const currentQuiz: QuizQuestion | undefined = topic.quizzes[quizIndex];

  const handleAnswer = (index: number) => {
    if (selectedAnswer !== null) return;
    setSelectedAnswer(index);
    setShowExplanation(true);
    if (index === currentQuiz.correctIndex) {
      setCorrectCount((c) => c + 1);
    }
  };

  const handleNextQuiz = () => {
    if (quizIndex < topic.quizzes.length - 1) {
      setQuizIndex((i) => i + 1);
      setSelectedAnswer(null);
      setShowExplanation(false);
    } else {
      const score = Math.round(((correctCount + (selectedAnswer === currentQuiz.correctIndex ? 0 : 0)) / topic.quizzes.length) * 100);
      const finalCorrect = correctCount + (selectedAnswer === currentQuiz.correctIndex ? 1 : 0);
      const finalScore = Math.round((finalCorrect / topic.quizzes.length) * 100);
      setQuizScore(topic.id, finalScore);
      setQuizComplete(true);
    }
  };

  const resetQuiz = () => {
    setQuizIndex(0);
    setSelectedAnswer(null);
    setShowExplanation(false);
    setCorrectCount(0);
    setQuizComplete(false);
  };

  const handleSaveNote = () => {
    setNote(topic.id, noteText);
  };

  const sections = [
    { key: "overview" as const, label: "Overview" },
    { key: "deepdive" as const, label: "Deep Dive" },
    { key: "quiz" as const, label: "Quiz" },
    { key: "notes" as const, label: "Notes" },
  ];

  return (
    <ScreenContainer>
      <ScrollView contentContainerStyle={{ paddingBottom: 32 }}>
        {/* Header */}
        <View className="px-5 pt-6 pb-2">
          <Pressable
            onPress={() => router.back()}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
          >
            <View className="flex-row items-center mb-4">
              <MaterialIcons name="arrow-back" size={20} color={colors.primary} />
              <Text className="text-sm text-primary ml-1">Back</Text>
            </View>
          </Pressable>

          <View className="flex-row items-start justify-between">
            <View className="flex-1 mr-3">
              <Text className="text-2xl font-bold text-foreground">{topic.title}</Text>
              <Text className="text-sm text-muted mt-1">{domain.title} · {topic.minutes} min</Text>
            </View>
            <View className="flex-row gap-2">
              <Pressable
                onPress={() => toggleBookmark(topic.id)}
                style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
              >
                <MaterialIcons
                  name={isBookmarked ? "bookmark" : "bookmark-border"}
                  size={24}
                  color={isBookmarked ? colors.warning : colors.muted}
                />
              </Pressable>
            </View>
          </View>

          {/* Difficulty */}
          <View className="flex-row items-center mt-2">
            <Text className="text-xs text-muted mr-2">Difficulty:</Text>
            {Array.from({ length: 3 }).map((_, i) => (
              <View
                key={i}
                className="w-3 h-3 rounded-full mr-1"
                style={{ backgroundColor: i < topic.difficulty ? domain.colorHex : colors.border }}
              />
            ))}
          </View>
        </View>

        {/* Section Tabs */}
        <ScrollView horizontal showsHorizontalScrollIndicator={false} contentContainerStyle={{ paddingHorizontal: 20, paddingVertical: 12 }}>
          {sections.map((section) => (
            <Pressable
              key={section.key}
              onPress={() => setActiveSection(section.key)}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            >
              <View
                className="px-4 py-2 rounded-full mr-2"
                style={{ backgroundColor: activeSection === section.key ? colors.primary : colors.surface }}
              >
                <Text
                  className="text-sm font-medium"
                  style={{ color: activeSection === section.key ? colors.background : colors.muted }}
                >
                  {section.label}
                </Text>
              </View>
            </Pressable>
          ))}
        </ScrollView>

        {/* Content */}
        <View className="px-5">
          {activeSection === "overview" && (
            <View>
              <View className="bg-surface rounded-xl p-4 border border-border mb-4">
                <Text className="text-sm text-foreground leading-6">{topic.overview}</Text>
              </View>
              <View className="bg-surface rounded-xl p-4 border border-border mb-4">
                <Text className="text-xs text-primary font-semibold uppercase tracking-wide mb-2">Workplace Application</Text>
                <Text className="text-sm text-foreground leading-6">{topic.workplaceUse}</Text>
              </View>
              <View className="bg-surface rounded-xl p-4 border border-border">
                <Text className="text-xs text-primary font-semibold uppercase tracking-wide mb-2">Key Terms</Text>
                <View className="flex-row flex-wrap gap-2">
                  {topic.keyTerms.map((term) => (
                    <View key={term} className="bg-border px-3 py-1 rounded-full">
                      <Text className="text-xs text-foreground">{term}</Text>
                    </View>
                  ))}
                </View>
              </View>
            </View>
          )}

          {activeSection === "deepdive" && (
            <View>
              {topic.deepDive.map((item, index) => (
                <View key={index} className="bg-surface rounded-xl p-4 border border-border mb-3">
                  <View className="flex-row items-start">
                    <View className="w-6 h-6 rounded-full bg-primary/20 items-center justify-center mr-3 mt-0.5">
                      <Text className="text-xs font-bold text-primary">{index + 1}</Text>
                    </View>
                    <Text className="text-sm text-foreground flex-1 leading-5">{item}</Text>
                  </View>
                </View>
              ))}
            </View>
          )}

          {activeSection === "quiz" && (
            <View>
              {quizComplete ? (
                <View className="bg-surface rounded-xl p-5 border border-border items-center">
                  <MaterialIcons
                    name="emoji-events"
                    size={48}
                    color={state.quizScores[topic.id] >= 70 ? colors.success : colors.warning}
                  />
                  <Text className="text-2xl font-bold text-foreground mt-3">
                    {state.quizScores[topic.id]}%
                  </Text>
                  <Text className="text-sm text-muted mt-1">
                    {correctCount + (selectedAnswer === currentQuiz?.correctIndex ? 1 : 0)}/{topic.quizzes.length} correct
                  </Text>
                  <Pressable
                    onPress={resetQuiz}
                    style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
                  >
                    <View className="bg-primary rounded-xl px-6 py-3 mt-4">
                      <Text className="text-sm font-semibold" style={{ color: colors.background }}>Retry Quiz</Text>
                    </View>
                  </Pressable>
                </View>
              ) : currentQuiz ? (
                <View>
                  <Text className="text-xs text-muted mb-3">Question {quizIndex + 1} of {topic.quizzes.length}</Text>
                  <View className="bg-surface rounded-xl p-4 border border-border mb-4">
                    <Text className="text-base font-medium text-foreground">{currentQuiz.question}</Text>
                  </View>
                  {currentQuiz.answers.map((answer, index) => {
                    let bgColor = colors.surface;
                    let borderColor = colors.border;
                    if (selectedAnswer !== null) {
                      if (index === currentQuiz.correctIndex) {
                        bgColor = colors.success + "20";
                        borderColor = colors.success;
                      } else if (index === selectedAnswer && index !== currentQuiz.correctIndex) {
                        bgColor = colors.error + "20";
                        borderColor = colors.error;
                      }
                    }
                    return (
                      <Pressable
                        key={index}
                        onPress={() => handleAnswer(index)}
                        style={({ pressed }) => [{ opacity: pressed ? 0.8 : 1 }]}
                      >
                        <View
                          className="rounded-xl p-4 mb-2 border"
                          style={{ backgroundColor: bgColor, borderColor }}
                        >
                          <Text className="text-sm text-foreground">{answer}</Text>
                        </View>
                      </Pressable>
                    );
                  })}
                  {showExplanation && (
                    <View className="bg-surface rounded-xl p-4 border border-primary mt-3 mb-3">
                      <Text className="text-xs text-primary font-semibold mb-1">Explanation</Text>
                      <Text className="text-sm text-foreground">{currentQuiz.explanation}</Text>
                    </View>
                  )}
                  {selectedAnswer !== null && (
                    <Pressable
                      onPress={handleNextQuiz}
                      style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
                    >
                      <View className="bg-primary rounded-xl p-4 items-center mt-2">
                        <Text className="text-base font-semibold" style={{ color: colors.background }}>
                          {quizIndex < topic.quizzes.length - 1 ? "Next Question" : "See Results"}
                        </Text>
                      </View>
                    </Pressable>
                  )}
                </View>
              ) : (
                <Text className="text-muted">No quiz available for this topic.</Text>
              )}
            </View>
          )}

          {activeSection === "notes" && (
            <View>
              <View className="bg-surface rounded-xl p-4 border border-border">
                <TextInput
                  className="text-sm text-foreground min-h-[120px]"
                  placeholder="Write your notes here..."
                  placeholderTextColor={colors.muted}
                  value={noteText}
                  onChangeText={setNoteText}
                  multiline
                  textAlignVertical="top"
                  returnKeyType="done"
                  onBlur={handleSaveNote}
                />
              </View>
              <Pressable
                onPress={handleSaveNote}
                style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
              >
                <View className="bg-primary rounded-xl p-3 items-center mt-3">
                  <Text className="text-sm font-semibold" style={{ color: colors.background }}>Save Notes</Text>
                </View>
              </Pressable>
            </View>
          )}
        </View>

        {/* Complete/Uncomplete Button */}
        <View className="px-5 mt-6">
          <Pressable
            onPress={() => isCompleted ? uncompleteTopic(topic.id) : completeTopic(topic.id)}
            style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
          >
            <View
              className="rounded-xl p-4 items-center flex-row justify-center"
              style={{ backgroundColor: isCompleted ? colors.surface : colors.success, borderWidth: isCompleted ? 1 : 0, borderColor: colors.border }}
            >
              <MaterialIcons
                name={isCompleted ? "replay" : "check-circle"}
                size={20}
                color={isCompleted ? colors.muted : colors.background}
              />
              <Text
                className="text-base font-semibold ml-2"
                style={{ color: isCompleted ? colors.muted : colors.background }}
              >
                {isCompleted ? "Mark as Incomplete" : "Mark as Complete"}
              </Text>
            </View>
          </Pressable>
        </View>
      </ScrollView>
    </ScreenContainer>
  );
}
