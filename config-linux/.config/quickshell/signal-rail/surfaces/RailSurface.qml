import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.theme

PanelWindow {
  required property var modelData
  required property Theme theme

  screen: modelData
  anchors.left: true
  anchors.right: true
  anchors.top: true
  implicitHeight: theme.metrics.railHeight
  exclusiveZone: 0
  color: "transparent"
  mask: Region {}

  WlrLayershell.namespace: "signal-rail-track"
  WlrLayershell.layer: WlrLayer.Bottom
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  Rectangle {
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.topMargin: theme.metrics.railLineTopMargin
    height: theme.metrics.railLineThickness
    gradient: Gradient {
      orientation: Gradient.Horizontal
      GradientStop { position: 0; color: theme.colors.primary }
      GradientStop { position: 0.5; color: theme.colors.secondary }
      GradientStop { position: 1; color: theme.colors.tertiary }
    }
  }
}
