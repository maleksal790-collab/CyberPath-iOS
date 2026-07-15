import { ScrollView, Text, View, Pressable } from "react-native";
import { useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { domains } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";

export default function HomeScreen() {
  const router = useRouter();
  const colors = useColors();
  const { state, getDomainProgress, getTotalTopics, getRecommendedNext } = useProgress();

  const totalTopics = getTotalTopics();
  const completedCount = state.completedTopicIds.length;
  const quizCount = Object.keys(state.quizScores).length;
  const avgQuizScore = quizCount > 0
    ? Math.round(Object.values(state.quizScores).reduce((a, b) => a + b, 0) / quizCount)
    : 0;
  const totalStudyMinutes = state.studySessions.reduce((sum, s) => sum + s.minutes, 0);
  const recommended = getRecommendedNext();

  const lastTopic = state.lastVisitedTopicId
    ? domains.flatMap((d) => d.topics).find((t) => t.id === state.lastVisitedTopicId)
    : null;
  const lastDomain = lastTopic
    ? domains.find((d) => d.topics.some((t) => t.id === lastTopic.id))
    : null;

  return (
    <ScreenContainer>
      <ScrollView contentContainerStyle={{ paddingBottom: 32 }}>
        <View className="px-5 pt-6 pb-4">
          <Text className="text-3xl font-bold text-foreground">CyberPath</Text>
          <Text className="text-base text-muted mt-1">Your cybersecurity learning journey</Text>
        </View>

        {/* Quick Stats */}
        <View className="flex-row px-5 gap-3 mb-5">
          <View className="flex-1 bg-surface rounded-xl p-3 border border-border">
            <Text className="text-2xl font-bold text-primary">{completedCount}</Text>
            <Text className="text-xs text-muted">Topics Done</Text>
          </View>
          <View className="flex-1 bg-surface rounded-xl p-3 border border-border">
            <Text className="text-2xl font-bold text-success">{avgQuizScore}%</Text>
            <Text className="text-xs text-muted">Quiz Avg</Text>
          </View>
          <View className="flex-1 bg-surface rounded-xl p-3 border border-border">
            <Text className="text-2xl font-bold text-warning">{totalStudyMinutes}m</Text>
            <Text className="text-xs text-muted">Study Time</Text>
          </View>
        </View>

        {/* Continue Learning */}
        {lastTopic && lastDomain && (
          <Pressable
            onPress={() => router.push(`/topic/${lastTopic.id}` as any)}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
          >
            <View className="mx-5 mb-5 bg-surface rounded-xl p-4 border border-border">
              <Text className="text-xs text-primary font-semibold uppercase tracking-wide mb-1">Continue Learning</Text>
              <Text className="text-lg font-semibold text-foreground">{lastTopic.title}</Text>
              <Text className="text-sm text-muted mt-1">{lastDomain.title} · {lastTopic.minutes} min</Text>
            </View>
          </Pressable>
        )}

        {/* Recommended Next */}
        {recommended && (
          <Pressable
            onPress={() => router.push(`/topic/${recommended.topicId}` as any)}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
          >
            <View className="mx-5 mb-5 bg-surface rounded-xl p-4 border border-primary">
              <Text className="text-xs text-success font-semibold uppercase tracking-wide mb-1">Recommended Next</Text>
              <Text className="text-lg font-semibold text-foreground">{recommended.topicTitle}</Text>
              <Text className="text-sm text-muted mt-1">{recommended.domainTitle}</Text>
            </View>
          </Pressable>
        )}

        {/* Domain Progress Overview */}
        <View className="px-5 mb-4">
          <Text className="text-lg font-semibold text-foreground mb-3">Domain Progress</Text>
          {domains.map((domain) => {
            const progress = getDomainProgress(domain.id);
            return (
              <View key={domain.id} className="mb-3">
                <View className="flex-row justify-between items-center mb-1">
                  <Text className="text-sm text-foreground">{domain.title}</Text>
                  <Text className="text-xs text-muted">{progress}%</Text>
                </View>
                <View className="h-2 bg-border rounded-full overflow-hidden">
                  <View
                    style={{ width: `${progress}%`, backgroundColor: domain.colorHex }}
                    className="h-full rounded-full"
                  />
                </View>
              </View>
            );
          })}
        </View>

        {/* Start Diagnostic CTA */}
        <Pressable
          onPress={() => router.push("/diagnostic" as any)}
          style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
        >
          <View className="mx-5 mb-5 bg-primary rounded-xl p-4 items-center">
            <MaterialIcons name="assessment" size={28} color={colors.background} />
            <Text className="text-base font-bold mt-2" style={{ color: colors.background }}>
              Take Readiness Diagnostic
            </Text>
            <Text className="text-sm mt-1" style={{ color: colors.background, opacity: 0.8 }}>
              20 questions across all domains
            </Text>
          </View>
        </Pressable>

        {/* Overall Progress */}
        <View className="mx-5 bg-surface rounded-xl p-4 border border-border">
          <Text className="text-sm text-muted mb-2">Overall Completion</Text>
          <Text className="text-3xl font-bold text-foreground">
            {totalTopics > 0 ? Math.round((completedCount / totalTopics) * 100) : 0}%
          </Text>
          <Text className="text-xs text-muted mt-1">{completedCount} of {totalTopics} topics completed</Text>
        </View>
      </ScrollView>
    </ScreenContainer>
  );
}
