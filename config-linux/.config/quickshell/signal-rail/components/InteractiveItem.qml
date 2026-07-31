import QtQuick
import qs.theme

Item {
  id: root

  required property Theme theme
  property string accessibleName: ""
  property bool interactiveEnabled: true
  readonly property bool hovered: hover.hovered
  readonly property bool pressed: tap.pressed
  readonly property bool keyboardFocused: activeFocus
  default property alias contentData: content.data

  signal activated
  signal secondaryActivated
  signal scrolled(real delta)

  activeFocusOnTab: interactiveEnabled
  enabled: interactiveEnabled
  Accessible.role: Accessible.Button
  Accessible.name: accessibleName

  Item {
    id: content
    anchors.fill: parent
  }

  HoverHandler { id: hover }
  TapHandler {
    id: tap
    acceptedButtons: Qt.LeftButton | Qt.RightButton
    onTapped: eventPoint => {
      if (eventPoint.button === Qt.RightButton)
        root.secondaryActivated()
      else
        root.activated()
    }
  }
  WheelHandler { onWheel: event => root.scrolled(event.angleDelta.y) }
  Keys.onReturnPressed: root.activated()
  Keys.onSpacePressed: root.activated()
}
