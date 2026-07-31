import QtQuick
import qs.theme

Text {
  id: root

  enum TextRole { LabelSmall, Label, Body, Title }

  required property Theme theme
  property int tone: SemanticRoles.Normal
  property int textRole: StyledText.Body
  property bool strong: false

  textFormat: Text.PlainText
  renderType: Text.NativeRendering
  color: theme.colors.forRole(tone)
  font.family: theme.type.bodyFamily
  font.pixelSize: textRole === StyledText.LabelSmall
    ? theme.type.labelSmall
    : textRole === StyledText.Label
      ? theme.type.label
      : textRole === StyledText.Title
        ? theme.type.title
        : theme.type.body
  font.weight: strong ? theme.type.strongWeight : theme.type.mediumWeight

  Behavior on color {
    ColorAnimation { duration: theme.motion.standard }
  }
}
