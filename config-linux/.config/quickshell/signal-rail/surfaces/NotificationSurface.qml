import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.features.notifications
import qs.models
import qs.services
import qs.theme

PanelWindow {
  id: root

  required property var modelData
  required property Theme theme
  required property NotificationService notificationService
  required property string closeGlyph

  readonly property string screenName: model.monitor !== null ? model.monitor.name : ""
  readonly property var visibleEntries: notificationService.entries.filter(entry =>
    entry.targetScreenName === screenName
      && entry.lifecycle !== NotificationEntry.Queued)

  screen: modelData
  anchors.left: true
  anchors.right: true
  anchors.top: true
  anchors.bottom: true
  exclusiveZone: 0
  color: "transparent"
  surfaceFormat.opaque: false
  visible: model.monitor !== null
  mask: Region { item: notificationStack }

  WlrLayershell.namespace: "signal-rail-notifications"
  WlrLayershell.exclusionMode: ExclusionMode.Ignore
  WlrLayershell.layer: WlrLayer.Overlay

  BarModel {
    id: model
    screen: root.modelData
  }

  Column {
    id: notificationStack

    anchors.top: parent.top
    anchors.topMargin: root.theme.metrics.railHeight + root.theme.metrics.notificationStackGap
    anchors.right: parent.right
    anchors.rightMargin: root.theme.metrics.capsuleHorizontalMargin
    width: root.theme.metrics.notificationWidth
    spacing: root.theme.metrics.notificationStackGap

    move: Transition {
      NumberAnimation {
        property: "y"
        duration: root.theme.motion.standard
        easing.type: root.theme.motion.effect
      }
    }

    Repeater {
      model: root.visibleEntries

      NotificationCard {
        required property var modelData
        width: notificationStack.width
        entry: modelData
        closeGlyph: root.closeGlyph
        theme: root.theme
      }
    }
  }

  onScreenNameChanged: if (screenName !== "")
    notificationService.setScreenFullscreen(screenName, model.monitorFullscreen)
  Connections {
    target: model
    function onMonitorFullscreenChanged() {
      if (root.screenName !== "")
        root.notificationService.setScreenFullscreen(root.screenName, model.monitorFullscreen)
    }
  }

  Component.onCompleted: {
    if (screenName !== "")
      notificationService.setScreenFullscreen(screenName, model.monitorFullscreen)
  }
  Component.onDestruction: {
    if (screenName !== "")
      notificationService.releaseScreen(screenName)
  }
}
