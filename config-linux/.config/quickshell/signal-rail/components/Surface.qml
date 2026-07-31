import QtQuick
import qs.theme

Rectangle {
  required property Theme theme
  property color fill: theme.colors.surface
  property color outline: theme.colors.outline
  property real cornerRadius: theme.metrics.cardRadius

  color: fill
  radius: cornerRadius
  border.width: theme.metrics.capsuleBorderWidth
  border.color: outline

  Behavior on color {
    ColorAnimation { duration: theme.motion.standard }
  }
  Behavior on border.color {
    ColorAnimation { duration: theme.motion.standard }
  }
}
