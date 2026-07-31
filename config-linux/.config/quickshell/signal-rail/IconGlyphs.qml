import QtQuick

QtObject {
  // Semantic icon mapping. Components should never carry raw glyphs.
  // Material Symbols Rounded ligature names.
  readonly property string clock: "schedule"
  readonly property string bluetooth: "bluetooth"
  readonly property string cpu: "memory"
  readonly property string memory: "memory_alt"
  readonly property string microphone: "mic"
  readonly property string headphones: "headphones"
  readonly property string appFallback: "apps"

  function network(wired, wifi, strength) {
    if (wired) return "lan"
    if (!wifi) return "signal_wifi_statusbar_not_connected"
    if (strength >= 75) return "network_wifi"
    if (strength >= 50) return "network_wifi_3_bar"
    if (strength >= 25) return "network_wifi_2_bar"
    return "network_wifi_1_bar"
  }
}
