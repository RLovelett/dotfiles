import QtQuick
import Quickshell.Services.Pipewire

QtObject {
  id: root

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource
  readonly property real sinkVolume: sink !== null && sink.audio !== null ? sink.audio.volume * 100 : 0
  readonly property real sourceVolume: source !== null && source.audio !== null ? source.audio.volume * 100 : 0
  readonly property bool sinkMuted: sink === null || sink.audio === null || sink.audio.muted
  readonly property bool sourceMuted: source === null || source.audio === null || source.audio.muted
  readonly property real volumeStep: 0.05

  function adjust(node, delta) {
    if (node === null || node.audio === null)
      return
    node.audio.volume = Math.max(0, Math.min(1, node.audio.volume + (delta > 0 ? volumeStep : -volumeStep)))
  }

  function toggleMute(node) {
    if (node !== null && node.audio !== null)
      node.audio.muted = !node.audio.muted
  }

  property PwObjectTracker tracker: PwObjectTracker {
    objects: [root.sink, root.source]
  }
}
