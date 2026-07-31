import QtQuick

QtObject {
  readonly property string clock: "schedule"
  readonly property string bluetooth: "bluetooth"
  readonly property string cpu: "memory"
  readonly property string memory: "memory_alt"
  readonly property string microphone: "mic"
  readonly property string headphones: "headphones"
  readonly property string appFallback: "apps"
  readonly property string close: "close"
  readonly property int wifiStrongThreshold: 75
  readonly property int wifiMediumThreshold: 50
  readonly property int wifiWeakThreshold: 25

  function network(wired, wifi, strength) {
    if (wired) return "lan"
    if (!wifi) return "signal_wifi_statusbar_not_connected"
    if (strength >= wifiStrongThreshold) return "network_wifi"
    if (strength >= wifiMediumThreshold) return "network_wifi_3_bar"
    if (strength >= wifiWeakThreshold) return "network_wifi_2_bar"
    return "network_wifi_1_bar"
  }
}
