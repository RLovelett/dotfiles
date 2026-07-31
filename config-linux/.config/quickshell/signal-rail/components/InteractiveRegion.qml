import QtQuick
import Quickshell

Region {
  required property Item target
  property real contentOffsetY: 0
  property real translationY: 0
  property int cornerRadius: 0
  property bool regionEnabled: true

  x: target.x
  y: contentOffsetY + target.y + translationY
  width: regionEnabled ? target.width : 0
  height: regionEnabled ? target.height : 0
  radius: cornerRadius
}
