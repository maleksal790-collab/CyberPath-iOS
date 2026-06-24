import { useState } from "react";
import { ScrollView, Text, View, Pressable, Alert, Platform } from "react-native";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { domains } from "@/lib/data";
import { useColors } from "@/hooks/use-colors";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";
import * as Sharing from "expo-sharing";
import * as FileSystem from "expo-file-system/legacy";

export default function ProgressScreen() {
  const colors = useColors();
  const {
    state,
    getDomainProgress,
    getReadinessLabel,
    getTotalTopics,
    getExportData,
    resetProgress,
  } = useProgress();
  const [showExport, setShowExport] = useState(false);

  const totalTopics = getTotalTopics();
  const completedCount = state.completedTopicIds.length;
  const overallPercent = totalTopics > 0 ? Math.round((completedCount / totalTopics) * 100) : 0;
  const quizCount = Object.keys(state.quizScores).length;
  const avgScore = quizCount > 0 ? Math.round(Object.values(state.quizScores).reduce((a, b) => a + b, 0) / quizCount) : 0;
  const totalStudyMin = state.studySessions.reduce((s, session) => s + session.minutes, 0);
  const scenarioCount = state.scenarioAttempts.length;

  const handleExport = async () => {
    try {
      const data = getExportData();
      if (Platform.OS === "web") {
        setShowExport(true);
        return;
      }
      const fileUri = FileSystem.documentDirectory + "cyberpath-progress.json";
      await FileSystem.writeAsStringAsync(fileUri, data);
      await Sharing.shareAsync(fileUri, { mimeType: "application/json" });
    } catch (e) {
      setShowExport(true);
    }
  };

  const handleReset = () => {
    if (Platform.OS === "web") {
      if (confirm("Are you sure you want to reset all progress? This cannot be undone.")) {
        resetProgress();
      }
    } else {
      Alert.alert(
        "Reset Progress",
        "Are you sure you want to reset all progress? This cannot be undone.",
        [
          { text: "Cancel", style: "cancel" },
          { text: "Reset", style: "destructive", onPress: resetProgress },
        ]
      );
    }
  };

  const readinessColor = (label: string) => {
    if (label === "Ready") return colors.success;
    if (label === "Developing") return colors.warning;
    if (label === "Emerging") return colors.error;
    return colors.muted;
  };

  return (
    <ScreenContainer>
      <ScrollView contentContainerStyle={{ paddingBottom: 32 }}>
        <View className="px-5 pt-6 pb-4">
          <Text className="text-3xl font-bold text-foreground">Progress</Text>
          <Text className="text-base text-muted mt-1">Your learning journey</Text>
        </View>

        {/* Journey Snapshot */}
        <View className="mx-5 bg-surface rounded-xl p-5 border border-border mb-4">
          <Text className="text-sm text-muted mb-3">Journey Snapshot</Text>
          <View className="items-center mb-4">
            <Text className="text-5xl font-bold text-primary">{overallPercent}%</Text>
            <Text className="text-sm text-muted mt-1">Overall Completion</Text>
          </View>
          <View className="flex-row justify-between">
            <View className="items-center flex-1">
              <Text className="text-xl font-bold text-foreground">{completedCount}</Text>
              <Text className="text-xs text-muted">Topics</Text>
            </View>
            <View className="items-center flex-1">
              <Text className="text-xl font-bold text-foreground">{avgScore}%</Text>
              <Text className="text-xs text-muted">Quiz Avg</Text>
            </View>
            <View className="items-center flex-1">
              <Text className="text-xl font-bold text-foreground">{totalStudyMin}m</Text>
              <Text className="text-xs text-muted">Study</Text>
            </View>
            <View className="items-center flex-1">
              <Text className="text-xl font-bold text-foreground">{scenarioCount}</Text>
              <Text className="text-xs text-muted">Scenarios</Text>
            </View>
          </View>
        </View>

        {/* Domain Progress */}
        <View className="mx-5 mb-4">
          <Text className="text-lg font-semibold text-foreground mb-3">Domain Progress</Text>
          {domains.map((domain) => {
            const progress = getDomainProgress(domain.id);
            const readiness = getReadinessLabel(domain.id);
            return (
              <View key={domain.id} className="bg-surface rounded-xl p-4 mb-2 border border-border">
                <View className="flex-row justify-between items-center mb-2">
                  <Text className="text-sm font-medium text-foreground">{domain.title}</Text>
                  <View className="flex-row items-center">
                    <View className="px-2 py-0.5 rounded" style={{ backgroundColor: readinessColor(readiness) + "20" }}>
                      <Text className="text-xs font-medium" style={{ color: readinessColor(readiness) }}>{readiness}</Text>
                    </View>
                  </View>
                </View>
                <View className="h-2 bg-border rounded-full overflow-hidden">
                  <View
                    style={{ width: `${progress}%`, backgroundColor: domain.colorHex }}
                    className="h-full rounded-full"
                  />
                </View>
                <Text className="text-xs text-muted mt-1">{progress}% · {domain.topics.filter((t) => state.completedTopicIds.includes(t.id)).length}/{domain.topics.length} topics</Text>
              </View>
            );
          })}
        </View>

        {/* Diagnostic Scores */}
        {Object.keys(state.diagnosticScores).length > 0 && (
          <View className="mx-5 mb-4">
            <Text className="text-lg font-semibold text-foreground mb-3">Diagnostic Scores</Text>
            <View className="bg-surface rounded-xl p-4 border border-border">
              {domains.map((domain) => {
                const score = state.diagnosticScores[domain.id];
                if (score === undefined) return null;
                return (
                  <View key={domain.id} className="flex-row justify-between items-center py-2 border-b border-border last:border-b-0">
                    <Text className="text-sm text-foreground">{domain.title}</Text>
                    <Text className="text-sm font-bold" style={{ color: readinessColor(getReadinessLabel(domain.id)) }}>
                      {score}%
                    </Text>
                  </View>
                );
              })}
            </View>
          </View>
        )}

        {/* Actions */}
        <View className="mx-5 gap-3">
          <Pressable
            onPress={handleExport}
            style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
          >
            <View className="bg-surface rounded-xl p-4 border border-border flex-row items-center">
              <MaterialIcons name="file-download" size={22} color={colors.primary} />
              <Text className="text-base font-medium text-foreground ml-3">Export Progress</Text>
            </View>
          </Pressable>

          <Pressable
            onPress={handleReset}
            style={({ pressed }) => [{ opacity: pressed ? 0.9 : 1, transform: [{ scale: pressed ? 0.97 : 1 }] }]}
          >
            <View className="bg-surface rounded-xl p-4 border border-error flex-row items-center">
              <MaterialIcons name="delete-outline" size={22} color={colors.error} />
              <Text className="text-base font-medium text-error ml-3">Reset All Progress</Text>
            </View>
          </Pressable>
        </View>

        {/* Export Modal (web fallback) */}
        {showExport && (
          <View className="mx-5 mt-4 bg-surface rounded-xl p-4 border border-border">
            <View className="flex-row justify-between items-center mb-2">
              <Text className="text-sm font-semibold text-foreground">Export Data</Text>
              <Pressable onPress={() => setShowExport(false)} style={({ pressed }) => [{ opacity: pressed ? 0.6 : 1 }]}>
                <MaterialIcons name="close" size={20} color={colors.muted} />
              </Pressable>
            </View>
            <Text className="text-xs text-muted mb-2">Copy the JSON below to save your progress:</Text>
            <View className="bg-background rounded-lg p-3 max-h-40">
              <Text className="text-xs text-foreground" selectable>{getExportData()}</Text>
            </View>
          </View>
        )}
      </ScrollView>
    </ScreenContainer>
  );
}
