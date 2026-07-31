import QtQuick
import Quickshell.Io

QtObject {
  id: root

  readonly property int refreshInterval: 10000
  property string address: "No address"

  property Process addressProcess: Process {
    id: addressProcess
    command: ["ip", "-j", "-4", "route", "get", "1.1.1.1"]
    running: true
    stdout: StdioCollector {
      onStreamFinished: {
        try {
          const routes = JSON.parse(text)
          root.address = routes.length > 0 && routes[0].prefsrc ? routes[0].prefsrc : "No address"
        } catch (error) {
          root.address = "No address"
        }
      }
    }
  }

  property Timer refreshTimer: Timer {
    // Route changes are cheap to sample and this avoids a long-lived socket helper.
    interval: root.refreshInterval
    repeat: true
    running: true
    onTriggered: if (!addressProcess.running) addressProcess.running = true
  }
}
