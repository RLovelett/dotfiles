import QtQuick
import Quickshell
import Quickshell.Wayland

PanelWindow {
  required property var modelData
  Theme { id: localTheme }
  property var theme: localTheme

  screen: modelData
  anchors.left: true
  anchors.right: true
  anchors.top: true
  implicitHeight: theme ? theme.railHeight : 48
  exclusiveZone: 0
  color: "transparent"
  mask: Region {}

  WlrLayershell.namespace: "signal-rail-track"
  // Keep the rail above hyprpaper even when the wallpaper layer is recreated.
  WlrLayershell.layer: WlrLayer.Bottom
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: theme ? theme.railLineTopMargin : 24
    height: 2
    gradient: Gradient {
      orientation: Gradient.Horizontal
      GradientStop { position: 0; color: theme.cyan }
      GradientStop { position: 0.5; color: theme.purple }
      GradientStop { position: 1; color: theme.pink }
    }
  }
}
