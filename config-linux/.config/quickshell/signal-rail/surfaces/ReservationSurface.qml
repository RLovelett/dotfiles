import Quickshell
import Quickshell.Wayland
import qs.theme

PanelWindow {
  required property var modelData
  required property Theme theme

  screen: modelData
  anchors.top: true
  implicitWidth: 1
  implicitHeight: 1
  exclusiveZone: theme.metrics.railHeight
  color: "transparent"
  mask: Region {}

  WlrLayershell.namespace: "signal-rail-reservation"
}
