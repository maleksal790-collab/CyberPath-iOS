import MaterialIcons from "@expo/vector-icons/MaterialIcons";
import { SymbolWeight, SymbolViewProps } from "expo-symbols";
import { ComponentProps } from "react";
import { OpaqueColorValue, type StyleProp, type TextStyle } from "react-native";

type IconMapping = Record<string, ComponentProps<typeof MaterialIcons>["name"]>;
type IconSymbolName = keyof typeof MAPPING;

const MAPPING = {
  "house.fill": "home",
  "book.closed.fill": "menu-book",
  "list.bullet.rectangle.portrait": "list-alt",
  "flask.fill": "science",
  "chart.xyaxis.line": "insights",
  "gauge.with.dots.needle.bottom.50percent": "speed",
  "paperplane.fill": "send",
  "chevron.left.forwardslash.chevron.right": "code",
  "chevron.right": "chevron-right",
  "checkmark.circle.fill": "check-circle",
  "bookmark.fill": "bookmark",
  "bookmark": "bookmark-border",
  "star.fill": "star",
  "arrow.right": "arrow-forward",
  "magnifyingglass": "search",
  "xmark": "close",
  "info.circle": "info",
  "exclamationmark.triangle": "warning",
  "lock.shield": "security",
  "network": "wifi",
  "cloud": "cloud",
  "doc.text": "description",
  "desktopcomputer": "computer",
  "shield": "shield",
} as IconMapping;

export function IconSymbol({
  name,
  size = 24,
  color,
  style,
}: {
  name: IconSymbolName;
  size?: number;
  color: string | OpaqueColorValue;
  style?: StyleProp<TextStyle>;
  weight?: SymbolWeight;
}) {
  const iconName = MAPPING[name as string] || "help-outline";
  return <MaterialIcons color={color} size={size} name={iconName} style={style} />;
}
