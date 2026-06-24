import { FlatList, Text, View, Pressable } from "react-native";
import { useLocalSearchParams, useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { domains } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";

export default function DomainDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const colors = useColors();
  const { state, getDomainProgress } = useProgress();

  const domain = domains.find((d) => d.id === id);
  if (!domain) {
    return (
      <ScreenContainer className="items-center justify-center">
        <Text className="text-foreground">Domain not found</Text>
      </ScreenContainer>
    );
  }

  const progress = getDomainProgress(domain.id);

  return (
    <ScreenContainer>
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
        <View className="flex-row items-center mb-2">
          <View
            className="w-12 h-12 rounded-xl items-center justify-center mr-3"
            style={{ backgroundColor: domain.colorHex + "20" }}
          >
            <MaterialIcons name="school" size={26} color={domain.colorHex} />
          </View>
          <View className="flex-1">
            <Text className="text-2xl font-bold text-foreground">{domain.title}</Text>
            <Text className="text-sm text-primary">{domain.stage} · {domain.topics.length} topics</Text>
          </View>
        </View>
        <Text className="text-sm text-muted mt-2 mb-3">{domain.summary}</Text>
        <View className="h-2 bg-border rounded-full overflow-hidden mb-1">
          <View
            style={{ width: `${progress}%`, backgroundColor: domain.colorHex }}
            className="h-full rounded-full"
          />
        </View>
        <Text className="text-xs text-muted mb-4">{progress}% complete</Text>
      </View>

      <FlatList
        data={domain.topics}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
        renderItem={({ item }) => {
          const isCompleted = state.completedTopicIds.includes(item.id);
          const isBookmarked = state.bookmarkedTopicIds.includes(item.id);
          const quizScore = state.quizScores[item.id];
          return (
            <Pressable
              onPress={() => router.push(`/topic/${item.id}` as any)}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            >
              <View className="bg-surface rounded-xl p-4 mb-2 border border-border">
                <View className="flex-row items-center">
                  <View className="flex-1">
                    <View className="flex-row items-center">
                      {isCompleted && (
                        <MaterialIcons name="check-circle" size={16} color={colors.success} style={{ marginRight: 6 }} />
                      )}
                      <Text className="text-base font-medium text-foreground">{item.title}</Text>
                    </View>
                    <View className="flex-row items-center mt-1">
                      <Text className="text-xs text-muted">{item.minutes} min</Text>
                      <View className="flex-row ml-2">
                        {Array.from({ length: 3 }).map((_, i) => (
                          <View
                            key={i}
                            className="w-2 h-2 rounded-full mr-0.5"
                            style={{ backgroundColor: i < item.difficulty ? domain.colorHex : colors.border }}
                          />
                        ))}
                      </View>
                      {quizScore !== undefined && (
                        <Text className="text-xs text-success ml-2">Quiz: {quizScore}%</Text>
                      )}
                    </View>
                  </View>
                  {isBookmarked && (
                    <MaterialIcons name="bookmark" size={18} color={colors.warning} style={{ marginRight: 8 }} />
                  )}
                  <MaterialIcons name="chevron-right" size={20} color={colors.muted} />
                </View>
              </View>
            </Pressable>
          );
        }}
      />

      {/* Capstone */}
      <View className="mx-5 mb-6 bg-surface rounded-xl p-4 border border-primary">
        <Text className="text-xs text-primary font-semibold uppercase tracking-wide mb-1">Capstone Project</Text>
        <Text className="text-sm text-foreground">{domain.capstone}</Text>
      </View>
    </ScreenContainer>
  );
}
