import { useState } from "react";
import { ScrollView, Text, View, Pressable } from "react-native";
import { useLocalSearchParams, useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { scenarios } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";
import type { ScenarioAction } from "@/lib/data";

export default function ScenarioDetailScreen() {
  const { id } = useLocalSearchParams<{ id: string }>();
  const router = useRouter();
  const colors = useColors();
  const { addScenarioAttempt } = useProgress();

  const [selectedAction, setSelectedAction] = useState<ScenarioAction | null>(null);
  const [showFollowUps, setShowFollowUps] = useState(false);

  const scenario = scenarios.find((s) => s.id === id);

  if (!scenario) {
    return (
      <ScreenContainer className="items-center justify-center">
        <Text className="text-foreground">Scenario not found</Text>
      </ScreenContainer>
    );
  }

  const handleSelectAction = (action: ScenarioAction) => {
    setSelectedAction(action);
    addScenarioAttempt(scenario.id, action.id, action.score);
  };

  const scoreColor = (score: number) => {
    if (score >= 80) return colors.success;
    if (score >= 50) return colors.warning;
    return colors.error;
  };

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
          <Text className="text-2xl font-bold text-foreground">{scenario.title}</Text>
          <Text className="text-sm text-muted mt-2">{scenario.summary}</Text>
        </View>

        {/* Evidence */}
        <View className="px-5 mt-4">
          <Text className="text-sm font-semibold text-primary uppercase tracking-wide mb-3">Evidence</Text>
          {scenario.evidence.map((item, index) => (
            <View key={index} className="bg-surface rounded-xl p-4 mb-2 border border-border">
              <Text className="text-sm font-semibold text-foreground mb-1">{item.title}</Text>
              <Text className="text-sm text-muted">{item.detail}</Text>
            </View>
          ))}
        </View>

        {/* Actions or Result */}
        {!selectedAction ? (
          <View className="px-5 mt-4">
            <Text className="text-sm font-semibold text-primary uppercase tracking-wide mb-3">Choose Your Response</Text>
            {scenario.actions.map((action) => (
              <Pressable
                key={action.id}
                onPress={() => handleSelectAction(action)}
                style={({ pressed }) => [{ opacity: pressed ? 0.8 : 1 }]}
              >
                <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                  <Text className="text-base font-medium text-foreground">{action.label}</Text>
                </View>
              </Pressable>
            ))}
          </View>
        ) : (
          <View className="px-5 mt-4">
            {/* Score */}
            <View className="bg-surface rounded-xl p-5 border border-border items-center mb-4">
              <Text className="text-4xl font-bold" style={{ color: scoreColor(selectedAction.score) }}>
                {selectedAction.score}
              </Text>
              <Text className="text-sm text-muted mt-1">out of 100</Text>
            </View>

            {/* Your Choice */}
            <View className="bg-surface rounded-xl p-4 border border-border mb-3">
              <Text className="text-xs text-primary font-semibold uppercase tracking-wide mb-1">Your Choice</Text>
              <Text className="text-sm font-medium text-foreground">{selectedAction.label}</Text>
            </View>

            {/* Feedback */}
            <View className="bg-surface rounded-xl p-4 border border-border mb-3">
              <Text className="text-xs text-primary font-semibold uppercase tracking-wide mb-1">Feedback</Text>
              <Text className="text-sm text-foreground leading-5">{selectedAction.feedback}</Text>
            </View>

            {/* Development */}
            <View className="bg-surface rounded-xl p-4 border border-border mb-3">
              <Text className="text-xs text-warning font-semibold uppercase tracking-wide mb-1">Development Tip</Text>
              <Text className="text-sm text-foreground leading-5">{selectedAction.development}</Text>
            </View>

            {/* Follow-ups */}
            {!showFollowUps ? (
              <Pressable
                onPress={() => setShowFollowUps(true)}
                style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
              >
                <View className="bg-primary rounded-xl p-4 items-center">
                  <Text className="text-base font-semibold" style={{ color: colors.background }}>
                    View Follow-Up Actions
                  </Text>
                </View>
              </Pressable>
            ) : (
              <View>
                <Text className="text-sm font-semibold text-primary uppercase tracking-wide mb-3">Follow-Up Actions</Text>
                {selectedAction.followUps.map((followUp) => (
                  <View
                    key={followUp.id}
                    className="bg-surface rounded-xl p-4 mb-2 border"
                    style={{ borderColor: followUp.recommended ? colors.success : colors.border }}
                  >
                    <View className="flex-row items-center mb-1">
                      {followUp.recommended ? (
                        <MaterialIcons name="check-circle" size={16} color={colors.success} style={{ marginRight: 6 }} />
                      ) : (
                        <MaterialIcons name="cancel" size={16} color={colors.error} style={{ marginRight: 6 }} />
                      )}
                      <Text className="text-sm font-medium text-foreground flex-1">{followUp.label}</Text>
                    </View>
                    <Text className="text-xs text-muted ml-6">{followUp.consequence}</Text>
                  </View>
                ))}
              </View>
            )}

            {/* Try Again */}
            <Pressable
              onPress={() => { setSelectedAction(null); setShowFollowUps(false); }}
              style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
            >
              <View className="bg-surface rounded-xl p-4 items-center mt-4 border border-border">
                <Text className="text-base font-medium text-muted">Try Different Response</Text>
              </View>
            </Pressable>
          </View>
        )}
      </ScrollView>
    </ScreenContainer>
  );
}
