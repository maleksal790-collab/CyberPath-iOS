import { FlatList, Text, View, Pressable } from "react-native";
import { useRouter } from "expo-router";
import { ScreenContainer } from "@/components/screen-container";
import { useProgress } from "@/lib/progress-store";
import { domains } from "@/lib/data";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";

const domainIcons: Record<string, string> = {
  "it-fundamentals": "computer",
  "networking": "wifi",
  "security-operations": "shield",
  "cloud-security": "cloud",
  "grc": "description",
};

export default function LearnScreen() {
  const router = useRouter();
  const { getDomainProgress } = useProgress();

  return (
    <ScreenContainer>
      <View className="px-5 pt-6 pb-4">
        <Text className="text-3xl font-bold text-foreground">Learn</Text>
        <Text className="text-base text-muted mt-1">Explore cybersecurity domains</Text>
      </View>
      <FlatList
        data={domains}
        keyExtractor={(item) => item.id}
        contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
        renderItem={({ item }) => {
          const progress = getDomainProgress(item.id);
          const iconName = domainIcons[item.id] || "folder";
          return (
            <Pressable
              onPress={() => router.push(`/domain/${item.id}` as any)}
              style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
            >
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <View className="flex-row items-center mb-2">
                  <View
                    className="w-10 h-10 rounded-lg items-center justify-center mr-3"
                    style={{ backgroundColor: item.colorHex + "20" }}
                  >
                    <MaterialIcons name={iconName as any} size={22} color={item.colorHex} />
                  </View>
                  <View className="flex-1">
                    <Text className="text-base font-semibold text-foreground">{item.title}</Text>
                    <Text className="text-xs text-primary">{item.stage} · {item.topics.length} topics</Text>
                  </View>
                  <MaterialIcons name="chevron-right" size={20} color="#94a3b8" />
                </View>
                <Text className="text-sm text-muted mb-3" numberOfLines={2}>{item.summary}</Text>
                <View className="h-2 bg-border rounded-full overflow-hidden">
                  <View
                    style={{ width: `${progress}%`, backgroundColor: item.colorHex }}
                    className="h-full rounded-full"
                  />
                </View>
                <Text className="text-xs text-muted mt-1">{progress}% complete</Text>
              </View>
            </Pressable>
          );
        }}
      />
    </ScreenContainer>
  );
}
