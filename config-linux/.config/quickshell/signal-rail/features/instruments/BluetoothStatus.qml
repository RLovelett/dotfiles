import QtQuick
import QtQuick.Layouts
import qs.components
import qs.theme

InteractiveItem {
  id: root

  required property string glyph
  required property bool adapterEnabled
  required property int connectedCount
  accessibleName: adapterEnabled ? `Bluetooth, ${connectedCount} connected` : "Bluetooth disabled"

  implicitWidth: 34
  implicitHeight: theme.metrics.capsuleHeight

  RowLayout {
    anchors.centerIn: parent
    spacing: root.theme.metrics.capsuleGap / 4
    Symbol {
      glyph: root.glyph
      tint: root.adapterEnabled ? root.theme.colors.primary : root.theme.colors.textMuted
      theme: root.theme
    }
    StyledText {
      text: root.connectedCount
      tone: root.connectedCount > 0 ? SemanticRoles.Normal : SemanticRoles.Muted
      theme: root.theme
      textRole: StyledText.LabelSmall
    }
  }

}
