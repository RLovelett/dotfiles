import QtQuick
import QtQuick.Layouts
import qs.components
import qs.theme

InteractiveItem {
  id: root

  required property string glyph
  required property string name
  required property string address
  required property bool available
  accessibleName: available ? `Network ${name}, ${address}` : "Network unavailable"

  implicitWidth: theme.metrics.networkStatusWidth
  implicitHeight: theme.metrics.capsuleHeight

  RowLayout {
    anchors.fill: parent
    spacing: root.theme.metrics.capsuleGap / 2

    Symbol {
      glyph: root.glyph
      tint: root.available ? root.theme.colors.highlight : root.theme.colors.critical
      theme: root.theme
    }
    ColumnLayout {
      spacing: 0
      StyledText {
        text: root.name
        tone: root.available ? SemanticRoles.Highlight : SemanticRoles.Critical
        theme: root.theme
        textRole: StyledText.LabelSmall
        elide: Text.ElideRight
        Layout.maximumWidth: root.theme.metrics.networkNameMaxWidth
      }
      StyledText {
        text: root.address
        tone: SemanticRoles.Muted
        theme: root.theme
        textRole: StyledText.LabelSmall
      }
    }
  }

}
