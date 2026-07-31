import QtQuick
import QtQuick.Layouts
import qs.theme

InteractiveItem {
  id: root

  property string title: ""
  property string label: ""
  property string icon: ""
  property real value: 0
  property bool muted: false
  property bool warning: false
  property bool critical: false
  property int accentTone: SemanticRoles.Primary

  accessibleName: title !== "" ? `${title} ${label}` : label

  implicitWidth: theme.metrics.metricWidth
  implicitHeight: theme.metrics.capsuleHeight

  readonly property color normalColor: theme.colors.forRole(accentTone)
  readonly property color accent: critical
    ? theme.colors.critical
    : warning
      ? theme.colors.warning
      : muted
        ? theme.colors.textMuted
        : normalColor

  RowLayout {
    anchors.fill: parent
    spacing: theme.metrics.capsuleGap / 2

    Symbol {
      visible: root.icon !== ""
      glyph: root.icon
      tint: root.accent
      theme: root.theme
      Layout.preferredWidth: root.theme.metrics.iconSlotSize
      Layout.preferredHeight: root.theme.metrics.iconSlotSize
      Layout.alignment: Qt.AlignVCenter
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: 0

      StyledText {
        visible: root.title !== ""
        text: root.title
        color: root.accent
        theme: root.theme
        textRole: StyledText.LabelSmall
      }

      StyledText {
        text: root.label
        tone: root.muted ? SemanticRoles.Muted : SemanticRoles.Normal
        theme: root.theme
        textRole: root.title === "" ? StyledText.Label : StyledText.LabelSmall
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: root.theme.metrics.metricTrackHeight
        radius: height / 2
        color: root.theme.colors.track

        Rectangle {
          width: parent.width * Math.max(0, Math.min(100, root.value)) / 100
          height: parent.height
          radius: height / 2
          color: root.accent

          Behavior on width {
            MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Short }
          }
        }
      }
    }
  }

}
