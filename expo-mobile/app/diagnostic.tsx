import { useState } from "react";
import { ScrollView, Text, View, Pressable } from "react-native";
import { useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { diagnosticQuestions, domains } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";

export default function DiagnosticScreen() {
  const router = useRouter();
  const colors = useColors();
  const { setDiagnosticScores } = useProgress();

  const [currentIndex, setCurrentIndex] = useState(0);
  const [answers, setAnswers] = useState<Record<string, number>>({});
  const [isComplete, setIsComplete] = useState(false);
  const [results, setResults] = useState<Record<string, number>>({});

  const currentQuestion = diagnosticQuestions[currentIndex];
  const progress = ((currentIndex) / diagnosticQuestions.length) * 100;

  const handleAnswer = (score: number) => {
    const newAnswers = { ...answers, [currentQuestion.id]: score };
    setAnswers(newAnswers);

    if (currentIndex < diagnosticQuestions.length - 1) {
      setCurrentIndex((i) => i + 1);
    } else {
      // Calculate scores per domain
      const domainScores: Record<string, number[]> = {};
      diagnosticQuestions.forEach((q) => {
        if (!domainScores[q.domainId]) domainScores[q.domainId] = [];
        const answerScore = newAnswers[q.id];
        if (answerScore !== undefined) domainScores[q.domainId].push(answerScore);
      });

      const finalScores: Record<string, number> = {};
      Object.entries(domainScores).forEach(([domainId, scores]) => {
        finalScores[domainId] = Math.round(scores.reduce((a, b) => a + b, 0) / scores.length);
      });

      setResults(finalScores);
      setDiagnosticScores(finalScores);
      setIsComplete(true);
    }
  };

  const getReadinessLabel = (score: number) => {
    if (score >= 75) return "Ready";
    if (score >= 45) return "Developing";
    return "Emerging";
  };

  const readinessColor = (label: string) => {
    if (label === "Ready") return colors.success;
    if (label === "Developing") return colors.warning;
    return colors.error;
  };

  if (isComplete) {
    return (
      <ScreenContainer>
        <ScrollView contentContainerStyle={{ paddingBottom: 32 }}>
          <View className="px-5 pt-6 pb-4">
            <Text className="text-2xl font-bold text-foreground">Diagnostic Results</Text>
            <Text className="text-sm text-muted mt-1">Your readiness assessment across domains</Text>
          </View>

          <View className="px-5">
            {domains.map((domain) => {
              const score = results[domain.id];
              if (score === undefined) return null;
              const label = getReadinessLabel(score);
              return (
                <View key={domain.id} className="bg-surface rounded-xl p-4 mb-3 border border-border">
                  <View className="flex-row items-center justify-between mb-2">
                    <Text className="text-base font-medium text-foreground">{domain.title}</Text>
                    <View className="px-3 py-1 rounded-full" style={{ backgroundColor: readinessColor(label) + "20" }}>
                      <Text className="text-xs font-bold" style={{ color: readinessColor(label) }}>{label}</Text>
                    </View>
                  </View>
                  <View className="h-3 bg-border rounded-full overflow-hidden">
                    <View
                      style={{ width: `${score}%`, backgroundColor: readinessColor(label) }}
                      className="h-full rounded-full"
                    />
                  </View>
                  <Text className="text-xs text-muted mt-1">{score}%</Text>
                </View>
              );
            })}
          </View>

          <Pressable
            onPress={() => router.back()}
            style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
          >
            <View className="mx-5 bg-primary rounded-xl p-4 items-center mt-4">
              <Text className="text-base font-semibold" style={{ color: colors.background }}>Done</Text>
            </View>
          </Pressable>
        </ScrollView>
      </ScreenContainer>
    );
  }

  return (
    <ScreenContainer>
      <ScrollView contentContainerStyle={{ paddingBottom: 32 }}>
        <View className="px-5 pt-6 pb-2">
          <Pressable
            onPress={() => router.back()}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
          >
            <View className="flex-row items-center mb-4">
              <MaterialIcons name="arrow-back" size={20} color={colors.primary} />
              <Text className="text-sm text-primary ml-1">Exit Diagnostic</Text>
            </View>
          </Pressable>
          <Text className="text-2xl font-bold text-foreground">Readiness Diagnostic</Text>
          <Text className="text-sm text-muted mt-1">Question {currentIndex + 1} of {diagnosticQuestions.length}</Text>

          {/* Progress bar */}
          <View className="h-2 bg-border rounded-full overflow-hidden mt-4">
            <View
              style={{ width: `${progress}%` }}
              className="h-full bg-primary rounded-full"
            />
          </View>
        </View>

        <View className="px-5 mt-6">
          {/* Domain badge */}
          <View className="mb-4">
            <Text className="text-xs text-primary font-semibold uppercase tracking-wide">
              {domains.find((d) => d.id === currentQuestion.domainId)?.title || "General"}
            </Text>
          </View>

          {/* Question */}
          <View className="bg-surface rounded-xl p-5 border border-border mb-6">
            <Text className="text-lg font-medium text-foreground leading-7">{currentQuestion.prompt}</Text>
          </View>

          {/* Answers */}
          {currentQuestion.answers.map((answer, index) => (
            <Pressable
              key={index}
              onPress={() => handleAnswer(answer.score)}
              style={({ pressed }) => [{ opacity: pressed ? 0.8 : 1 }]}
            >
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <Text className="text-base text-foreground">{answer.label}</Text>
              </View>
            </Pressable>
          ))}
        </View>
      </ScrollView>
    </ScreenContainer>
  );
}
