import QtQuick
import qs.theme

Surface {
  id: root

  enum AccentRole { Neutral, Primary, Secondary, Tertiary }

  property int accentRole: Capsule.Neutral
  property real contentWidth: 0
  property int horizontalPadding: theme.metrics.capsulePadding

  implicitWidth: contentWidth + horizontalPadding * 2
  implicitHeight: theme.metrics.capsuleHeight
  height: implicitHeight
  // Expansion changes the surface bounds, not the capsule's corner language.
  cornerRadius: theme.metrics.capsuleHeight / 2
  outline: accentRole === Capsule.Primary
    ? theme.colors.primary
    : accentRole === Capsule.Secondary
      ? theme.colors.secondary
      : accentRole === Capsule.Tertiary
        ? theme.colors.tertiary
        : theme.colors.outline

}
