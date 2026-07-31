import QtQuick
import QtQuick.Layouts
import qs.theme

InteractiveItem {
  id: root

  property string text: ""
  property string glyph: ""
  property int tone: SemanticRoles.Primary

  accessibleName: text

  implicitWidth: contentRow.implicitWidth + theme.metrics.capsulePadding * 2
  implicitHeight: theme.metrics.actionHeight

  Rectangle {
    anchors.fill: parent
    radius: root.theme.metrics.actionRadius
    color: root.pressed
      ? root.theme.colors.interactionPressed
      : root.hovered || root.keyboardFocused
        ? root.theme.colors.interactionHover
        : root.theme.colors.surface
    border.width: root.theme.metrics.capsuleBorderWidth
    border.color: root.theme.colors.forRole(root.tone)
  }

  RowLayout {
    id: contentRow
    anchors.centerIn: parent
    spacing: root.theme.metrics.capsuleGap / 2

    Symbol {
      visible: root.glyph !== ""
      glyph: root.glyph
      tint: root.theme.colors.forRole(root.tone)
      theme: root.theme
    }
    StyledText {
      visible: root.text !== ""
      text: root.text
      tone: root.tone
      theme: root.theme
      textRole: StyledText.Body
    }
  }
}
