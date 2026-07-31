import Quickshell
import Quickshell.Wayland

PanelWindow {
  required property var modelData

  screen: modelData
  anchors.top: true
  implicitWidth: 1
  implicitHeight: 1
  exclusiveZone: 40
  color: "transparent"
  mask: Region {}

  WlrLayershell.namespace: "signal-rail-reservation"
}
