import QtQuick
import Quickshell
import Quickshell.Wayland
import qs.components
import qs.features.activewindow
import qs.features.clock
import qs.features.instruments
import qs.features.workspaces
import qs.models
import qs.services
import qs.theme

PanelWindow {
  id: root

  required property var modelData
  required property Theme theme
  required property SystemStats stats
  required property ConnectivityService connectivity
  required property AudioService audio
  required property AppService appService
  required property WorkspacePreviewService workspacePreview
  required property IconGlyphs glyphs

  screen: modelData
  anchors.left: true
  anchors.right: true
  anchors.top: true
  anchors.bottom: true
  exclusiveZone: 0
  color: "transparent"
  surfaceFormat.opaque: false
  visible: model.monitor !== null && !model.monitorFullscreen
  mask: Region {
    InteractiveRegion {
      target: workspaceCapsule
      contentOffsetY: barContent.y
      cornerRadius: root.theme.metrics.capsuleHeight / 2
    }
    InteractiveRegion {
      target: activeWindowCapsule
      contentOffsetY: barContent.y
      translationY: appReveal.y
      cornerRadius: root.theme.metrics.capsuleHeight / 2
      regionEnabled: activeWindowCapsule.visible
    }
    InteractiveRegion {
      target: clockCapsule
      contentOffsetY: barContent.y
      translationY: clockReveal.y
      cornerRadius: root.theme.metrics.capsuleHeight / 2
      regionEnabled: clockCapsule.visible
    }
    InteractiveRegion {
      target: instrumentsCapsule
      contentOffsetY: barContent.y
      translationY: instrumentsReveal.y
      cornerRadius: root.theme.metrics.capsuleHeight / 2
      regionEnabled: instrumentsCapsule.visible
    }
  }

  WlrLayershell.namespace: "signal-rail-bar"
  WlrLayershell.exclusionMode: ExclusionMode.Ignore

  function enterFromTop() {
    enterAnimation.stop()
    barContent.y = -theme.metrics.railHeight
    enterFrame.running = true
  }

  onVisibleChanged: if (visible) enterFromTop()

  FrameAnimation {
    id: enterFrame
    running: false
    onTriggered: {
      running = false
      if (root.visible)
        enterAnimation.restart()
    }
  }

  BarModel {
    id: model
    screen: root.modelData
  }

  Item {
    id: barContent
    anchors.fill: parent
    y: -root.theme.metrics.railHeight

    NumberAnimation {
      id: enterAnimation
      target: barContent
      property: "y"
      to: 0
      duration: root.theme.motion.barEnter
      easing.type: root.theme.motion.spatialOut
    }

    WorkspaceCapsule {
      id: workspaceCapsule
      anchors.left: parent.left
      anchors.leftMargin: root.theme.metrics.capsuleHorizontalMargin
      anchors.top: parent.top
      anchors.topMargin: root.theme.metrics.capsuleTopMargin
      theme: root.theme
      workspaces: model.visibleWorkspaces
      scratchpad: model.scratchpad
      monitorFocused: model.monitorFocused
      urgencyPreviewWorkspaceId: root.workspacePreview.urgentWorkspaceId
    }

    ActiveWindowCapsule {
      id: activeWindowCapsule
      visible: model.activeToplevel !== null
      anchors.left: workspaceCapsule.right
      anchors.leftMargin: root.theme.metrics.capsuleGap
      anchors.top: parent.top
      anchors.topMargin: root.theme.metrics.capsuleTopMargin
      opacity: model.monitorFocused && model.activeToplevel !== null ? 1 : 0
      theme: root.theme
      entry: model.activeEntry
      appName: model.activeAppName
      appIcon: model.activeAppIcon
      title: model.activeTitle
      fallbackGlyph: root.glyphs.appFallback
      transform: VerticalReveal {
        id: appReveal
        theme: root.theme
        shown: model.monitorFocused && model.activeToplevel !== null
      }

      Behavior on opacity { MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Short } }
    }

    ClockCapsule {
      id: clockCapsule
      visible: true
      anchors.horizontalCenter: parent.horizontalCenter
      anchors.top: parent.top
      anchors.topMargin: root.theme.metrics.capsuleTopMargin
      opacity: model.monitorFocused ? 1 : 0
      theme: root.theme
      clockGlyph: root.glyphs.clock
      transform: VerticalReveal {
        id: clockReveal
        theme: root.theme
        shown: model.monitorFocused
      }

      Behavior on opacity { MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Short } }
    }

    InstrumentsCapsule {
      id: instrumentsCapsule
      visible: true
      anchors.right: parent.right
      anchors.rightMargin: root.theme.metrics.capsuleHorizontalMargin
      anchors.top: parent.top
      anchors.topMargin: root.theme.metrics.capsuleTopMargin
      opacity: model.monitorFocused ? 1 : 0
      theme: root.theme
      stats: root.stats
      connectivity: root.connectivity
      audio: root.audio
      appService: root.appService
      glyphs: root.glyphs
      transform: VerticalReveal {
        id: instrumentsReveal
        theme: root.theme
        shown: model.monitorFocused
      }

      Behavior on opacity { MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Short } }
    }
  }

  Component.onCompleted: enterFromTop()
}
