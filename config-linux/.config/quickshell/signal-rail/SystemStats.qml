import QtQuick
import Quickshell.Io

QtObject {
  id: root

  property real cpuUsage: 0
  property real memoryUsage: 0
  property double previousIdle: 0
  property double previousTotal: 0

  function parseCpu(text) {
    const line = text.split("\n")[0]
    const fields = line.trim().split(/\s+/).slice(1).map(Number)
    if (fields.length < 8)
      return

    const idle = fields[3] + fields[4]
    const total = fields.reduce((sum, value) => sum + value, 0)
    const totalDelta = total - previousTotal
    const idleDelta = idle - previousIdle

    if (previousTotal > 0 && totalDelta > 0)
      cpuUsage = Math.max(0, Math.min(100, 100 * (totalDelta - idleDelta) / totalDelta))

    previousIdle = idle
    previousTotal = total
  }

  function parseMemory(text) {
    const values = {}
    for (const line of text.split("\n")) {
      const match = line.match(/^([^:]+):\s+(\d+)/)
      if (match)
        values[match[1]] = Number(match[2])
    }

    const total = values.MemTotal || 0
    const available = values.MemAvailable || 0
    if (total > 0)
      memoryUsage = Math.max(0, Math.min(100, 100 * (total - available) / total))
  }

  property FileView cpuFile: FileView {
    path: "file:///proc/stat"
    blockLoading: true
    onTextChanged: root.parseCpu(text())
  }

  property FileView memoryFile: FileView {
    path: "file:///proc/meminfo"
    blockLoading: true
    onTextChanged: root.parseMemory(text())
  }

  property Timer refreshTimer: Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      root.cpuFile.reload()
      root.memoryFile.reload()
    }
  }
}
