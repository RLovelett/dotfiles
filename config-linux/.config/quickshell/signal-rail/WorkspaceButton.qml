import QtQuick

Item {
  id: root

  required property var style
  required property var workspace
  property bool special: false
  signal activated

  implicitWidth: 27
  implicitHeight: style.capsuleHeight

  readonly property bool globallyFocused: !special && workspace.focused
  readonly property bool monitorActive: !special && workspace.active
  readonly property bool urgent: !special && workspace.urgent

  Rectangle {
    id: circle
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: 6
    width: 20
    height: 20
    radius: 10
    color: root.globallyFocused ? root.style.cyan : root.style.background
    border.width: root.monitorActive ? 1.5 : 1
    border.color: root.urgent
      ? root.style.orange
      : root.globallyFocused
        ? root.style.cyan
        : root.monitorActive
          ? root.style.purple
          : root.style.selection

    Text {
      anchors.fill: parent
      text: root.special ? "󰘔" : root.workspace.name
      color: root.globallyFocused
        ? root.style.activeText
        : root.monitorActive
          ? root.style.cyan
          : root.style.foregroundMuted
      font.family: "MesloLGSDZ Nerd Font Mono"
      font.pixelSize: root.special ? 10 : 9
      font.weight: root.globallyFocused ? Font.DemiBold : Font.Medium
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }

    Rectangle {
      visible: root.urgent
      width: 5
      height: 5
      radius: 2.5
      color: root.style.orange
      anchors.right: parent.right
      anchors.top: parent.top
      anchors.rightMargin: -1
      anchors.topMargin: -1
    }

    Behavior on color { ColorAnimation { duration: 150 } }
    Behavior on border.color { ColorAnimation { duration: 150 } }
  }

  Rectangle {
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    visible: root.globallyFocused || root.urgent || (root.special && root.workspace.active)
    width: root.globallyFocused ? 17 : 14
    height: 2
    radius: 1
    color: root.urgent
      ? root.style.orange
      : root.special
        ? root.style.purple
        : root.style.cyan

    Behavior on width { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
  }

  HoverHandler { id: hover }
  TapHandler { onTapped: root.activated() }

  scale: hover.hovered ? 1.08 : 1
  Behavior on scale { NumberAnimation { duration: 100 } }
}
