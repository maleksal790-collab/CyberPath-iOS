import { FlatList, Text, View, Pressable } from "react-native";
import { useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { scenarios } from "@/lib/data";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";
import { useColors } from "@/hooks/use-colors";

export default function PracticeScreen() {
  const router = useRouter();
  const colors = useColors();
  const { state } = useProgress();

  return (
    <ScreenContainer>
      <View className="px-5 pt-6 pb-4">
        <Text className="text-3xl font-bold text-foreground">Practice</Text>
        <Text className="text-base text-muted mt-1">Scenario-based decision making</Text>
      </View>
      <FlatList
        data={scenarios}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
        renderItem={({ item }) => {
          const attempts = state.scenarioAttempts.filter((a) => a.scenarioId === item.id);
          const bestScore = attempts.length > 0 ? Math.max(...attempts.map((a) => a.score)) : null;
          return (
            <Pressable
              onPress={() => router.push(`/scenario/${item.id}` as any)}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            >
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <View className="flex-row items-start">
                  <View className="w-10 h-10 rounded-lg items-center justify-center mr-3 bg-warning/20">
                    <MaterialIcons name="science" size={22} color={colors.warning} />
                  </View>
                  <View className="flex-1">
                    <Text className="text-base font-semibold text-foreground">{item.title}</Text>
                    <Text className="text-sm text-muted mt-1" numberOfLines={2}>{item.summary}</Text>
                    <View className="flex-row items-center mt-2">
                      <Text className="text-xs text-muted">{item.evidence.length} evidence items · {item.actions.length} choices</Text>
                      {bestScore !== null && (
                        <View className="ml-auto bg-success/20 px-2 py-0.5 rounded">
                          <Text className="text-xs font-medium text-success">Best: {bestScore}/100</Text>
                        </View>
                      )}
                    </View>
                  </View>
                </View>
              </View>
            </Pressable>
          );
        }}
      />
    </ScreenContainer>
  );
}
