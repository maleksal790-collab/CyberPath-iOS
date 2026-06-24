import { useState } from "react";
import { FlatList, Text, View, Pressable, ScrollView } from "react-native";
import { ScreenContainer } from "@/components/screen-container";
import { visualLessons } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";

export default function VisualsScreen() {
  const colors = useColors();
  const [selectedLesson, setSelectedLesson] = useState<string | null>(null);
  const [revealedPrompts, setRevealedPrompts] = useState<Record<string, number>>({});

  const activeLesson = visualLessons.find((l) => l.id === selectedLesson);
  const currentRevealCount = selectedLesson ? (revealedPrompts[selectedLesson] || 0) : 0;

  const revealNext = () => {
    if (!selectedLesson) return;
    setRevealedPrompts((prev) => ({
      ...prev,
      [selectedLesson]: Math.min((prev[selectedLesson] || 0) + 1, activeLesson?.prompts.length || 0),
    }));
  };

  if (activeLesson) {
    return (
      <ScreenContainer>
        <ScrollView contentContainerStyle={{ paddingBottom: 32 }}>
          <View className="px-5 pt-6 pb-4">
            <Pressable
              onPress={() => setSelectedLesson(null)}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            >
              <View className="flex-row items-center mb-4">
                <MaterialIcons name="arrow-back" size={20} color={colors.primary} />
                <Text className="text-sm text-primary ml-1">Back to Lessons</Text>
              </View>
            </Pressable>
            <Text className="text-2xl font-bold text-foreground">{activeLesson.title}</Text>
            <Text className="text-sm text-muted mt-2">{activeLesson.summary}</Text>
          </View>

          <View className="px-5">
            {activeLesson.prompts.slice(0, currentRevealCount).map((prompt, index) => (
              <View key={index} className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <View className="flex-row items-start">
                  <View className="w-7 h-7 rounded-full bg-primary/20 items-center justify-center mr-3 mt-0.5">
                    <Text className="text-xs font-bold text-primary">{index + 1}</Text>
                  </View>
                  <Text className="text-sm text-foreground flex-1 leading-5">{prompt}</Text>
                </View>
              </View>
            ))}

            {currentRevealCount < activeLesson.prompts.length && (
              <Pressable
                onPress={revealNext}
                style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
              >
                <View className="bg-primary rounded-xl p-4 items-center">
                  <Text className="text-base font-semibold" style={{ color: colors.background }}>
                    Reveal Next Prompt ({currentRevealCount}/{activeLesson.prompts.length})
                  </Text>
                </View>
              </Pressable>
            )}

            {currentRevealCount >= activeLesson.prompts.length && (
              <View className="bg-success/20 rounded-xl p-4 items-center border border-success">
                <MaterialIcons name="check-circle" size={24} color={colors.success} />
                <Text className="text-sm font-medium text-success mt-2">All prompts revealed!</Text>
                <Text className="text-xs text-muted mt-1">Reflect on each prompt and apply to real scenarios.</Text>
              </View>
            )}
          </View>
        </ScrollView>
      </ScreenContainer>
    );
  }

  return (
    <ScreenContainer>
      <View className="px-5 pt-6 pb-4">
        <Text className="text-3xl font-bold text-foreground">Visuals</Text>
        <Text className="text-base text-muted mt-1">Interactive guided exercises</Text>
      </View>
      <FlatList
        data={visualLessons}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
        renderItem={({ item }) => {
          const revealed = revealedPrompts[item.id] || 0;
          return (
            <Pressable
              onPress={() => setSelectedLesson(item.id)}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            >
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <View className="flex-row items-start">
                  <View className="w-10 h-10 rounded-lg items-center justify-center mr-3 bg-primary/20">
                    <MaterialIcons name="insights" size={22} color={colors.primary} />
                  </View>
                  <View className="flex-1">
                    <Text className="text-base font-semibold text-foreground">{item.title}</Text>
                    <Text className="text-sm text-muted mt-1" numberOfLines={2}>{item.summary}</Text>
                    <Text className="text-xs text-primary mt-2">{item.prompts.length} prompts · {revealed} revealed</Text>
                  </View>
                  <MaterialIcons name="chevron-right" size={20} color={colors.muted} />
                </View>
              </View>
            </Pressable>
          );
        }}
      />
    </ScreenContainer>
  );
}
