import QtQuick
import QtQuick.Layouts

Item {
  id: root

  required property var theme
  property string title: ""
  property string label: ""
  property string icon: ""
  property real value: 0
  property bool muted: false
  property bool warning: false
  property bool critical: false
  property color normalColor: theme.cyan
  property string tooltipText: ""
  signal clicked
  signal rightClicked
  signal scrolled(real delta)

  implicitWidth: 64
  implicitHeight: theme.capsuleHeight

  readonly property color accent: critical
    ? theme.red
    : warning
      ? theme.orange
      : muted
        ? theme.comment
        : normalColor

  RowLayout {
    anchors.fill: parent
    spacing: 5

    RailIcon {
      visible: root.icon !== ""
      glyph: root.icon
      tint: root.accent
      theme: root.theme
      Layout.preferredWidth: root.theme.iconSlotSize
      Layout.preferredHeight: root.theme.iconSlotSize
      Layout.alignment: Qt.AlignVCenter
    }

    ColumnLayout {
      Layout.fillWidth: true
      Layout.alignment: Qt.AlignVCenter
      spacing: 0

      Text {
        visible: root.title !== ""
        text: root.title
        color: root.muted
          ? root.theme.comment
          : root.accent
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 8
        font.weight: Font.Medium
      }

      Text {
        text: root.label
        color: root.muted ? root.theme.comment : root.theme.foreground
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.weight: Font.Medium
        font.pixelSize: root.title === "" ? 9 : 8
      }

      Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 2
        radius: 1
        color: root.theme.track

        Rectangle {
          width: parent.width * Math.max(0, Math.min(100, root.value)) / 100
          height: parent.height
          radius: 1
          color: root.accent

          Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
        }
      }
    }
  }

  HoverHandler { id: hover }

  TapHandler {
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onTapped: eventPoint => {
      if (eventPoint.button === Qt.RightButton)
        root.rightClicked()
      else
        root.clicked()
    }
  }

  WheelHandler {
    onWheel: event => root.scrolled(event.angleDelta.y)
  }
}
