import QtQuick

Rectangle {
  id: root

  required property var theme
  property color outlineColor: theme.capsuleOutline

  height: theme.capsuleHeight
  radius: height / 2
  color: theme.capsuleFill
  border.width: 2
  border.color: outlineColor
}
