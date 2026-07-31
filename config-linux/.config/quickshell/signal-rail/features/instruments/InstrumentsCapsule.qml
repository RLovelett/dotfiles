import QtQuick
import QtQuick.Layouts
import qs.components
import qs.services
import qs.theme

Capsule {
  id: root

  required property SystemStats stats
  required property ConnectivityService connectivity
  required property AudioService audio
  required property AppService appService
  required property IconGlyphs glyphs

  accentRole: Capsule.Tertiary
  contentWidth: instrumentRow.implicitWidth

  readonly property string networkGlyph: glyphs.network(
    connectivity.networkIsWired,
    connectivity.networkIsWifi,
    connectivity.wifiStrength)

  RowLayout {
    id: instrumentRow
    anchors.centerIn: parent
    spacing: root.theme.metrics.capsuleGap * 5 / 6

    NetworkStatus {
      theme: root.theme
      glyph: root.networkGlyph
      name: root.connectivity.networkName
      address: root.connectivity.networkAddress
      available: root.connectivity.networkAvailable
      onActivated: root.appService.focusOrLaunchTui("impala", "wifi")
    }

    Divider { theme: root.theme }

    BluetoothStatus {
      theme: root.theme
      glyph: root.glyphs.bluetooth
      adapterEnabled: root.connectivity.bluetoothEnabled
      connectedCount: root.connectivity.bluetoothCount
      onActivated: root.appService.focusOrLaunchTui("bluetui", "bluetooth")
    }

    Divider { theme: root.theme }

    Metric {
      theme: root.theme
      icon: root.glyphs.cpu
      title: "CPU"
      label: `${Math.round(root.stats.cpuUsage)}%`
      value: root.stats.cpuUsage
      accentTone: SemanticRoles.Warning
      warning: value >= root.theme.metrics.resourceWarningPercent
      critical: value >= root.theme.metrics.resourceCriticalPercent
      onActivated: root.appService.focusOrLaunchTui("btop", "")
    }

    Metric {
      theme: root.theme
      icon: root.glyphs.memory
      title: "RAM"
      label: `${Math.round(root.stats.memoryUsage)}%`
      value: root.stats.memoryUsage
      accentTone: SemanticRoles.Tertiary
      warning: value >= root.theme.metrics.resourceWarningPercent
      critical: value >= root.theme.metrics.resourceCriticalPercent
      onActivated: root.appService.focusOrLaunchTui("btop", "")
    }

    Divider { theme: root.theme }

    Metric {
      theme: root.theme
      icon: root.glyphs.microphone
      label: `${Math.round(root.audio.sourceVolume)}%`
      value: root.audio.sourceVolume
      muted: root.audio.sourceMuted
      accentTone: SemanticRoles.Success
      onActivated: root.appService.focusOrLaunchTui("wiremix", "")
      onSecondaryActivated: root.audio.toggleMute(root.audio.source)
      onScrolled: delta => root.audio.adjust(root.audio.source, delta)
    }

    Metric {
      theme: root.theme
      icon: root.glyphs.headphones
      label: `${Math.round(root.audio.sinkVolume)}%`
      value: root.audio.sinkVolume
      muted: root.audio.sinkMuted
      accentTone: SemanticRoles.Secondary
      onActivated: root.appService.focusOrLaunchTui("wiremix", "")
      onSecondaryActivated: root.audio.toggleMute(root.audio.sink)
      onScrolled: delta => root.audio.adjust(root.audio.sink, delta)
    }
  }
}
