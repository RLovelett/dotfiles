import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Hyprland
import Quickshell.Networking
import Quickshell.Services.Pipewire
import Quickshell.Wayland
import Quickshell.Widgets

PanelWindow {
  id: bar

  Theme { id: theme }
  IconGlyphs { id: glyphs }

  property var modelData
  property var stats
  property var networkInfo

  screen: modelData
  anchors.left: true
  anchors.right: true
  anchors.top: true
  anchors.bottom: true
  exclusiveZone: 0
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  color: "transparent"
  surfaceFormat.opaque: false
  mask: Region {
    Region { item: workspacePill }
    Region { item: appPill }
    Region { item: clockPill }
    Region { item: instrumentsPill }
  }

  readonly property var monitor: Hyprland.monitorFor(screen)
  readonly property bool monitorFocused: monitor !== null && monitor.focused
  readonly property bool monitorFullscreen: monitor !== null && monitor.activeWorkspace !== null && monitor.activeWorkspace.hasFullscreen
  visible: monitor !== null && !monitorFullscreen

  readonly property var visibleWorkspaces: {
    if (monitor === null)
      return []

    return Hyprland.workspaces.values
      .filter(workspace => workspace.id > 0
        && workspace.monitor !== null
        && workspace.monitor.name === monitor.name
        && (workspace.active || workspace.toplevels.values.length > 0))
      .sort((a, b) => a.id - b.id)
  }

  readonly property var scratchpad: Hyprland.workspaces.values.find(workspace =>
    workspace.name === "special:scratchpad"
      && workspace.monitor !== null
      && monitor !== null
      && workspace.monitor.name === monitor.name
      && (workspace.active || workspace.toplevels.values.length > 0)) || null

  readonly property var activeToplevel: monitorFocused ? Hyprland.activeToplevel : null
  readonly property string activeClass: {
    if (activeToplevel === null)
      return ""
    if (activeToplevel.wayland !== null && activeToplevel.wayland.appId !== "")
      return activeToplevel.wayland.appId
    return activeToplevel.lastIpcObject.class || activeToplevel.lastIpcObject.initialClass || ""
  }
  readonly property var activeEntry: activeClass === "" ? null : DesktopEntries.heuristicLookup(activeClass)
  readonly property string activeAppName: activeEntry !== null ? activeEntry.name : humanize(activeClass)
  readonly property string activeAppIcon: activeEntry !== null && activeEntry.icon !== "" ? activeEntry.icon : "application-x-executable"
  readonly property string activeTitle: activeToplevel === null ? "" : (activeToplevel.lastIpcObject.title || activeAppName)

  readonly property var connectedDevice: Networking.devices.values.find(device => device.connected) || null
  readonly property var connectedNetwork: {
    if (connectedDevice === null || connectedDevice.type !== DeviceType.Wifi)
      return null
    return connectedDevice.networks.values.find(network => network.connected) || null
  }
  readonly property bool networkIsWifi: connectedDevice !== null && connectedDevice.type === DeviceType.Wifi
  readonly property bool networkIsWired: connectedDevice !== null && connectedDevice.type === DeviceType.Wired
  readonly property string networkName: networkIsWifi && connectedNetwork !== null ? connectedNetwork.name : networkIsWired ? "Ethernet" : "Offline"
  readonly property string networkAddress: connectedDevice !== null ? networkInfo.address : "No address"
  readonly property real wifiStrength: connectedNetwork !== null ? connectedNetwork.signalStrength : 0
  readonly property string networkIcon: glyphs.network(networkIsWired, networkIsWifi, wifiStrength)
  readonly property int bluetoothCount: Bluetooth.devices.values.filter(device => device.connected).length
  readonly property bool bluetoothEnabled: Bluetooth.defaultAdapter !== null && Bluetooth.defaultAdapter.enabled

  readonly property var sink: Pipewire.defaultAudioSink
  readonly property var source: Pipewire.defaultAudioSource
  readonly property real sinkVolume: sink !== null && sink.audio !== null ? sink.audio.volume * 100 : 0
  readonly property real sourceVolume: source !== null && source.audio !== null ? source.audio.volume * 100 : 0
  readonly property bool sinkMuted: sink === null || sink.audio === null || sink.audio.muted
  readonly property bool sourceMuted: source === null || source.audio === null || source.audio.muted

  PwObjectTracker {
    objects: [bar.sink, bar.source]
  }

  function humanize(value) {
    if (!value)
      return "Desktop"
    const base = value.split(".").pop().replace(/[-_]/g, " ")
    return base.charAt(0).toUpperCase() + base.slice(1)
  }

  function focusOrLaunchTui(command, unblock) {
    const appId = `me.lovelett.hyprland.${command}`
    const existing = Hyprland.toplevels.values.find(toplevel => {
      const className = toplevel.lastIpcObject.class || ""
      return className === appId
    })

    if (existing !== undefined) {
      Hyprland.dispatch(`focuswindow class:^${appId}$`)
      return
    }

    if (unblock !== "")
      Quickshell.execDetached(["rfkill", "unblock", unblock])
    Quickshell.execDetached(["uwsm", "app", "--", "xdg-terminal-exec", `--app-id=${appId}`, "-e", command])
  }

  function adjustAudio(node, delta) {
    if (node === null || node.audio === null)
      return
    node.audio.volume = Math.max(0, Math.min(1, node.audio.volume + (delta > 0 ? 0.05 : -0.05)))
  }

  function calendarCells(date) {
    const year = date.getFullYear()
    const month = date.getMonth()
    const firstDay = new Date(year, month, 1).getDay()
    const days = new Date(year, month + 1, 0).getDate()
    const cells = []
    for (let i = 0; i < 42; ++i) {
      const day = i - firstDay + 1
      cells.push(day > 0 && day <= days ? day : 0)
    }
    return cells
  }

  function isoWeek(date) {
    const value = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()))
    value.setUTCDate(value.getUTCDate() + 4 - (value.getUTCDay() || 7))
    const start = new Date(Date.UTC(value.getUTCFullYear(), 0, 1))
    return Math.ceil((((value - start) / 86400000) + 1) / 7)
  }

  function twelveHourTime(date, withSeconds) {
    const hour = ((date.getHours() + 11) % 12) + 1
    const minute = String(date.getMinutes()).padStart(2, "0")
    const second = String(date.getSeconds()).padStart(2, "0")
    return withSeconds ? `${hour}:${minute}:${second}` : `${hour}:${minute}`
  }

  Pill {
    id: workspacePill
    property bool entered: false
    anchors.left: parent.left
    anchors.leftMargin: theme.capsuleHorizontalMargin
    anchors.top: parent.top
    anchors.topMargin: entered ? theme.capsuleTopMargin : -33
    width: workspaceRow.implicitWidth + 24
    theme: theme
    outlineColor: bar.monitorFocused ? theme.capsuleOutlineStrong : theme.capsuleOutline

    Component.onCompleted: entered = true
    Behavior on anchors.topMargin { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

    RowLayout {
      id: workspaceRow
      anchors.fill: parent
      anchors.leftMargin: 12
      anchors.rightMargin: 12
      spacing: 4

      Repeater {
        model: ScriptModel { values: bar.visibleWorkspaces }

        WorkspaceButton {
          required property var modelData
          style: theme
          workspace: modelData
          onActivated: modelData.activate()
        }
      }

      WorkspaceButton {
        visible: bar.scratchpad !== null
        style: theme
        workspace: bar.scratchpad || ({ name: "scratchpad", focused: false, active: false, urgent: false })
        special: true
        onActivated: Hyprland.dispatch("togglespecialworkspace scratchpad")
      }
    }
  }

  Pill {
    id: appPill
    property bool entered: false
    visible: opacity > 0.01 && bar.activeToplevel !== null
    anchors.left: workspacePill.right
    anchors.leftMargin: theme.capsuleGap
    anchors.top: parent.top
    anchors.topMargin: entered && bar.monitorFocused ? theme.capsuleTopMargin : -33
    width: Math.max(82, appRow.implicitWidth + 22)
    opacity: bar.monitorFocused && bar.activeToplevel !== null ? 1 : 0
    theme: theme
    outlineColor: theme.capsuleOutlineStrong

    Behavior on opacity { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
    Component.onCompleted: entered = true
    Behavior on anchors.topMargin { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

    RowLayout {
      id: appRow
      anchors.centerIn: parent
      spacing: 6

      IconImage {
        visible: source !== ""
        source: bar.activeEntry !== null ? Quickshell.iconPath(bar.activeAppIcon, "application-x-executable") : ""
        implicitSize: 20
        Layout.preferredWidth: 20
        Layout.preferredHeight: 20
      }

      RailIcon {
        visible: bar.activeEntry === null
        glyph: glyphs.appFallback
        tint: theme.cyan
        theme: theme
        pointSize: theme.iconSize
      }

      Text {
        text: bar.activeAppName
        color: theme.foreground
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 10
        font.weight: Font.Medium
        elide: Text.ElideRight
        Layout.maximumWidth: 150
      }
    }

    HoverHandler { id: appHover }
  }

  PopupWindow {
    id: appTooltip
    anchor.item: appPill
    anchor.edges: Edges.Bottom
    anchor.gravity: Edges.Bottom
    anchor.margins.top: 7
    visible: appHover.hovered && appPill.visible
    implicitWidth: Math.min(460, Math.max(180, appTitle.implicitWidth + 24))
    implicitHeight: 34
    color: "transparent"

    Rectangle {
      anchors.fill: parent
      radius: 10
      color: theme.surface
      border.color: theme.capsuleOutlineStrong
      border.width: 2

      Text {
        id: appTitle
        anchors.centerIn: parent
        width: Math.min(436, implicitWidth)
        text: bar.activeTitle
        color: theme.foreground
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 10
        elide: Text.ElideRight
      }
    }
  }

  Pill {
    id: clockPill
    property bool entered: false
    readonly property bool expanded: clockHover.hovered
    readonly property real collapsedWidth: collapsedClockHeader.implicitWidth + 24
    visible: opacity > 0.01
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.top: parent.top
    anchors.topMargin: entered && bar.monitorFocused ? theme.capsuleTopMargin : -33
    width: collapsedWidth
    height: theme.capsuleHeight
    radius: theme.capsuleHeight / 2
    opacity: bar.monitorFocused ? 1 : 0
    theme: theme
    outlineColor: theme.capsuleOutlineAccent
    clip: true

    Behavior on opacity { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
    Component.onCompleted: entered = true
    Behavior on anchors.topMargin { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }
    states: [
      State {
        name: "expanded"
        when: clockPill.expanded
        PropertyChanges { target: clockPill; width: 280; height: 230 }
      },
      State {
        name: "collapsed"
        when: !clockPill.expanded
        PropertyChanges { target: clockPill; width: clockPill.collapsedWidth; height: theme.capsuleHeight }
      }
    ]

    transitions: [
      Transition {
        from: "collapsed"
        to: "expanded"
        SequentialAnimation {
          NumberAnimation { property: "width"; duration: 80; easing.type: Easing.OutCubic }
          NumberAnimation { property: "height"; duration: 115; easing.type: Easing.OutCubic }
        }
      },
      Transition {
        from: "expanded"
        to: "collapsed"
        SequentialAnimation {
          NumberAnimation { property: "height"; duration: 100; easing.type: Easing.InCubic }
          NumberAnimation { property: "width"; duration: 70; easing.type: Easing.InCubic }
        }
      }
    ]

    SystemClock {
      id: clock
      precision: clockPill.expanded ? SystemClock.Seconds : SystemClock.Minutes
    }

    RowLayout {
      id: collapsedClockHeader
      anchors.centerIn: parent
      anchors.horizontalCenter: parent.horizontalCenter
      height: theme.clockHeaderHeight
      spacing: 6
      opacity: !clockPill.expanded || clockPill.width < 258 ? 1 : 0

      Behavior on opacity { NumberAnimation { duration: 70 } }

      RailIcon {
        glyph: glyphs.clock
        tint: theme.cyan
        theme: theme
        pointSize: theme.clockIconSize
        Layout.preferredWidth: theme.iconSlotSize
        Layout.preferredHeight: theme.iconSlotSize
      }

      Text {
        text: bar.twelveHourTime(clock.date, false)
        color: theme.foreground
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 16
        font.weight: Font.Medium
      }

      Text {
        text: `${Qt.formatDateTime(clock.date, "AP")} · ${Qt.formatDateTime(clock.date, "ddd, d MMM")}`
        color: theme.foregroundMuted
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 9
      }
    }

    RowLayout {
      id: expandedClockHeader
      anchors.top: parent.top
      anchors.topMargin: 6
      anchors.horizontalCenter: parent.horizontalCenter
      height: 22
      spacing: 6
      opacity: clockPill.expanded && clockPill.width >= 252 ? 1 : 0

      Behavior on opacity { NumberAnimation { duration: 70 } }

      RailIcon {
        glyph: glyphs.clock
        tint: theme.cyan
        theme: theme
        pointSize: theme.clockIconSize
        Layout.preferredWidth: theme.iconSlotSize
        Layout.preferredHeight: theme.iconSlotSize
      }

      Text {
        text: bar.twelveHourTime(clock.date, true)
        color: theme.foreground
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 16
        font.weight: Font.Medium
      }

      Text {
        text: `${Qt.formatDateTime(clock.date, "AP")} · ${Qt.formatDateTime(clock.date, "ddd, d MMM")} · ${Qt.formatDateTime(clock.date, "HH:mm")}`
        color: theme.foregroundMuted
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 9
      }
    }

    ColumnLayout {
      anchors.top: parent.top
      anchors.topMargin: 34
      anchors.left: parent.left
      anchors.right: parent.right
      anchors.leftMargin: 12
      anchors.rightMargin: 12
      spacing: 8
      opacity: clockPill.expanded && clockPill.height > 165 ? 1 : 0

      Behavior on opacity { NumberAnimation { duration: 75 } }

      Text {
        text: `${Qt.formatDateTime(clock.date, "MMMM yyyy")}  ·  week ${bar.isoWeek(clock.date)}`
        color: theme.purple
        font.family: "MesloLGSDZ Nerd Font Mono"
        font.pixelSize: 9
      }

      GridLayout {
        columns: 7
        columnSpacing: 3
        rowSpacing: 3
        Layout.fillWidth: true

        Repeater {
          model: ["S", "M", "T", "W", "T", "F", "S"]
          Text {
            required property string modelData
            text: modelData
            color: theme.comment
            horizontalAlignment: Text.AlignHCenter
            font.family: "MesloLGSDZ Nerd Font Mono"
            font.pixelSize: 8
            Layout.preferredWidth: 27
          }
        }

        Repeater {
          model: bar.calendarCells(clock.date)
          Rectangle {
            required property int modelData
            readonly property bool today: modelData === clock.date.getDate()
            color: today ? theme.purple : "transparent"
            radius: 8
            Layout.preferredWidth: 27
            Layout.preferredHeight: 19
            Text {
              anchors.centerIn: parent
              text: modelData === 0 ? "" : modelData
              color: parent.today ? theme.foreground : theme.foregroundMuted
              font.family: "MesloLGSDZ Nerd Font Mono"
              font.pixelSize: 8
            }
          }
        }
      }
    }

    HoverHandler { id: clockHover }
  }

  Pill {
    id: instrumentsPill
    property bool entered: false
    visible: opacity > 0.01
    anchors.right: parent.right
    anchors.rightMargin: theme.capsuleHorizontalMargin
    anchors.top: parent.top
    anchors.topMargin: entered && bar.monitorFocused ? theme.capsuleTopMargin : -33
    width: instrumentRow.implicitWidth + 24
    opacity: bar.monitorFocused ? 1 : 0
    theme: theme
    outlineColor: theme.capsuleOutlineRight

    Behavior on opacity { NumberAnimation { duration: 100; easing.type: Easing.OutCubic } }
    Component.onCompleted: entered = true
    Behavior on anchors.topMargin { NumberAnimation { duration: 110; easing.type: Easing.OutCubic } }

    RowLayout {
      id: instrumentRow
      anchors.centerIn: parent
      spacing: 10

      Item {
        implicitWidth: 126
        implicitHeight: theme.capsuleHeight

        RowLayout {
          anchors.fill: parent
          spacing: 6
          RailIcon {
            glyph: bar.networkIcon
            tint: bar.connectedDevice === null ? theme.red : theme.cyan
            theme: theme
            Layout.preferredWidth: theme.iconSlotSize
            Layout.preferredHeight: theme.iconSlotSize
          }
          ColumnLayout {
            spacing: 0
            Text {
              text: bar.networkName
              color: bar.connectedDevice === null ? theme.red : theme.cyan
              font.family: "MesloLGSDZ Nerd Font Mono"
              font.pixelSize: 8
              elide: Text.ElideRight
              Layout.maximumWidth: 90
            }
            Text {
              text: bar.networkAddress
              color: theme.foregroundMuted
              font.family: "MesloLGSDZ Nerd Font Mono"
              font.pixelSize: 8
            }
          }
        }
        HoverHandler { id: networkHover }
        TapHandler { onTapped: bar.focusOrLaunchTui("impala", "wifi") }
      }

      Rectangle { Layout.preferredWidth: 2; Layout.preferredHeight: 18; color: theme.separator }

      Item {
        implicitWidth: 34
        implicitHeight: theme.capsuleHeight
        RowLayout {
          anchors.centerIn: parent
          spacing: 3
          RailIcon {
            glyph: glyphs.bluetooth
            tint: bar.bluetoothEnabled ? theme.cyan : theme.comment
            theme: theme
            Layout.preferredWidth: theme.iconSlotSize
            Layout.preferredHeight: theme.iconSlotSize
          }
          Text {
            text: bar.bluetoothCount
            color: bar.bluetoothCount > 0 ? theme.foreground : theme.comment
            font.family: "MesloLGSDZ Nerd Font Mono"
            font.pixelSize: 8
          }
        }
        HoverHandler { id: bluetoothHover }
        TapHandler { onTapped: bar.focusOrLaunchTui("bluetui", "bluetooth") }
      }

      Rectangle { Layout.preferredWidth: 2; Layout.preferredHeight: 18; color: theme.separator }

      Metric {
        icon: glyphs.cpu
        title: "CPU"
        label: `${Math.round(bar.stats.cpuUsage)}%`
        value: bar.stats.cpuUsage
        theme: theme
        normalColor: theme.orange
        warning: value >= 80
        critical: value >= 95
        onClicked: bar.focusOrLaunchTui("btop", "")
      }

      Metric {
        icon: glyphs.memory
        title: "RAM"
        label: `${Math.round(bar.stats.memoryUsage)}%`
        value: bar.stats.memoryUsage
        theme: theme
        normalColor: theme.pink
        warning: value >= 80
        critical: value >= 95
        onClicked: bar.focusOrLaunchTui("btop", "")
      }

      Rectangle { Layout.preferredWidth: 2; Layout.preferredHeight: 18; color: theme.separator }

      Metric {
        icon: glyphs.microphone
        label: `${Math.round(bar.sourceVolume)}%`
        value: bar.sourceVolume
        muted: bar.sourceMuted
        theme: theme
        normalColor: theme.green
        onClicked: bar.focusOrLaunchTui("wiremix", "")
        onRightClicked: if (bar.source !== null && bar.source.audio !== null) bar.source.audio.muted = !bar.source.audio.muted
        onScrolled: delta => bar.adjustAudio(bar.source, delta)
      }

      Metric {
        icon: glyphs.headphones
        label: `${Math.round(bar.sinkVolume)}%`
        value: bar.sinkVolume
        muted: bar.sinkMuted
        theme: theme
        normalColor: theme.purple
        onClicked: bar.focusOrLaunchTui("wiremix", "")
        onRightClicked: if (bar.sink !== null && bar.sink.audio !== null) bar.sink.audio.muted = !bar.sink.audio.muted
        onScrolled: delta => bar.adjustAudio(bar.sink, delta)
      }
    }
  }
}
