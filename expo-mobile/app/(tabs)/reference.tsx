import { useState } from "react";
import { FlatList, Text, View, Pressable, TextInput } from "react-native";
import { ScreenContainer } from "@/components/screen-container";
import { useColors } from "@/hooks/use-colors";
import { glossaryTerms, portItems, frameworks, securityMetrics, toolCategories } from "@/lib/data";
import MaterialIcons from "@expo/vector-icons/MaterialIcons";

type TabKey = "glossary" | "ports" | "frameworks" | "metrics" | "tools";

const tabs: { key: TabKey; label: string }[] = [
  { key: "glossary", label: "Glossary" },
  { key: "ports", label: "Ports" },
  { key: "frameworks", label: "Frameworks" },
  { key: "metrics", label: "Metrics" },
  { key: "tools", label: "Tools" },
];

export default function ReferenceScreen() {
  const colors = useColors();
  const [activeTab, setActiveTab] = useState<TabKey>("glossary");
  const [search, setSearch] = useState("");

  const filteredGlossary = glossaryTerms.filter(
    (t) => t.term.toLowerCase().includes(search.toLowerCase()) || t.definition.toLowerCase().includes(search.toLowerCase())
  );
  const filteredPorts = portItems.filter(
    (p) => p.description.toLowerCase().includes(search.toLowerCase()) || String(p.port).includes(search)
  );
  const filteredFrameworks = frameworks.filter(
    (f) => f.framework.toLowerCase().includes(search.toLowerCase()) || f.bestFor.toLowerCase().includes(search.toLowerCase())
  );
  const filteredMetrics = securityMetrics.filter(
    (m) => m.metric.toLowerCase().includes(search.toLowerCase()) || m.fullName.toLowerCase().includes(search.toLowerCase())
  );
  const filteredTools = toolCategories.filter(
    (t) => t.category.toLowerCase().includes(search.toLowerCase()) || t.tools.some((tool) => tool.toLowerCase().includes(search.toLowerCase()))
  );

  const renderContent = () => {
    switch (activeTab) {
      case "glossary":
        return (
          <FlatList
            data={filteredGlossary}
            keyExtractor={(item) => item.id}
            contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
            renderItem={({ item }) => (
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <Text className="text-base font-semibold text-foreground">{item.term}</Text>
                <Text className="text-sm text-muted mt-1">{item.definition}</Text>
              </View>
            )}
          />
        );
      case "ports":
        return (
          <FlatList
            data={filteredPorts}
            keyExtractor={(item) => `${item.port}-${item.protocol}`}
            contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
            renderItem={({ item }) => (
              <View className="bg-surface rounded-xl p-4 mb-2 border border-border flex-row items-center">
                <View className="w-16">
                  <Text className="text-base font-bold text-primary">{item.port}</Text>
                  <Text className="text-xs text-muted">{item.protocol}</Text>
                </View>
                <Text className="text-sm text-foreground flex-1">{item.description}</Text>
              </View>
            )}
          />
        );
      case "frameworks":
        return (
          <FlatList
            data={filteredFrameworks}
            keyExtractor={(item) => item.id}
            contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
            renderItem={({ item }) => (
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <Text className="text-base font-bold text-foreground">{item.framework}</Text>
                <View className="mt-2">
                  <Text className="text-xs text-primary mb-1">Scope: <Text className="text-muted">{item.scope}</Text></Text>
                  <Text className="text-xs text-primary mb-1">Approach: <Text className="text-muted">{item.approach}</Text></Text>
                  <Text className="text-xs text-primary mb-1">Structure: <Text className="text-muted">{item.structure}</Text></Text>
                  <Text className="text-xs text-primary">Best For: <Text className="text-muted">{item.bestFor}</Text></Text>
                </View>
              </View>
            )}
          />
        );
      case "metrics":
        return (
          <FlatList
            data={filteredMetrics}
            keyExtractor={(item) => item.id}
            contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
            renderItem={({ item }) => (
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <View className="flex-row items-center mb-1">
                  <View className="bg-primary/20 px-2 py-1 rounded mr-2">
                    <Text className="text-xs font-bold text-primary">{item.metric}</Text>
                  </View>
                  <Text className="text-sm font-semibold text-foreground flex-1">{item.fullName}</Text>
                </View>
                <Text className="text-sm text-muted mt-1">{item.description}</Text>
                <View className="flex-row mt-2">
                  <Text className="text-xs text-success">Target: {item.target}</Text>
                  <Text className="text-xs text-muted ml-3">Category: {item.category}</Text>
                </View>
              </View>
            )}
          />
        );
      case "tools":
        return (
          <FlatList
            data={filteredTools}
            keyExtractor={(item) => item.id}
            contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 32 }}
            renderItem={({ item }) => (
              <View className="bg-surface rounded-xl p-4 mb-3 border border-border">
                <Text className="text-base font-semibold text-foreground mb-2">{item.category}</Text>
                <View className="flex-row flex-wrap gap-2">
                  {item.tools.map((tool) => (
                    <View key={tool} className="bg-border px-3 py-1 rounded-full">
                      <Text className="text-xs text-foreground">{tool}</Text>
                    </View>
                  ))}
                </View>
              </View>
            )}
          />
        );
    }
  };

  return (
    <ScreenContainer>
      <View className="px-5 pt-6 pb-3">
        <Text className="text-3xl font-bold text-foreground">Reference</Text>
        <Text className="text-base text-muted mt-1">Quick-access security knowledge</Text>
      </View>

      {/* Search */}
      <View className="px-5 mb-3">
        <View className="bg-surface border border-border rounded-xl flex-row items-center px-3">
          <MaterialIcons name="search" size={20} color={colors.muted} />
          <TextInput
            className="flex-1 py-3 px-2 text-sm text-foreground"
            placeholder="Search..."
            placeholderTextColor={colors.muted}
            value={search}
            onChangeText={setSearch}
            returnKeyType="done"
          />
          {search.length > 0 && (
            <Pressable onPress={() => setSearch("")} style={({ pressed }) => [{ opacity: pressed ? 0.6 : 1 }]}>
              <MaterialIcons name="close" size={18} color={colors.muted} />
            </Pressable>
          )}
        </View>
      </View>

      {/* Tabs */}
      <FlatList
        horizontal
        data={tabs}
        keyExtractor={(item) => item.key}
        showsHorizontalScrollIndicator={false}
        contentContainerStyle={{ paddingHorizontal: 20, paddingBottom: 12 }}
        renderItem={({ item }) => (
          <Pressable
            onPress={() => setActiveTab(item.key)}
            style={({ pressed }) => [{ opacity: pressed ? 0.7 : 1 }]}
          >
            <View
              className="px-4 py-2 rounded-full mr-2"
              style={{ backgroundColor: activeTab === item.key ? colors.primary : colors.surface }}
            >
              <Text
                className="text-sm font-medium"
                style={{ color: activeTab === item.key ? colors.background : colors.muted }}
              >
                {item.label}
              </Text>
            </View>
          </Pressable>
        )}
      />

      {/* Content */}
      {renderContent()}
    </ScreenContainer>
  );
}
