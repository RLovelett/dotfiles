import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Notifications
import Quickshell.Widgets
import qs.components
import qs.services
import qs.theme

Card {
  id: root

  required property NotificationEntry entry
  required property string closeGlyph

  readonly property bool entering: entry.lifecycle === NotificationEntry.Entering
  readonly property bool closing: entry.lifecycle === NotificationEntry.Closing
  readonly property real motionScale: theme.motion.reducedMotion ? 0 : 1

  minimumWidth: theme.metrics.notificationWidth
  maximumWidth: theme.metrics.notificationWidth
  tone: entry.urgency === NotificationUrgency.Critical
    ? SemanticRoles.Critical
    : entry.urgency === NotificationUrgency.Low
      ? SemanticRoles.Muted
      : SemanticRoles.Primary
  opacity: entering || closing ? 0 : 1
  scale: entering ? 0.98 : 1

  transform: Translate {
    y: root.entering
      ? -root.theme.metrics.notificationEnterOffset * root.motionScale
      : root.closing
        ? -root.theme.metrics.notificationExitOffset * root.motionScale
        : 0

    Behavior on y {
      MotionAnimation {
        theme: root.theme
        motionRole: root.closing ? MotionAnimation.Standard : MotionAnimation.Emphasized
        easing.type: root.closing ? root.theme.motion.spatialIn : root.theme.motion.spatialOut
      }
    }
  }

  Behavior on opacity {
    MotionAnimation {
      theme: root.theme
      motionRole: root.closing ? MotionAnimation.Standard : MotionAnimation.Emphasized
      easing.type: root.closing ? root.theme.motion.spatialIn : root.theme.motion.spatialOut
    }
  }

  Behavior on scale {
    MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Emphasized }
  }

  HoverHandler {
    id: hover
    onHoveredChanged: root.entry.setHovered(hovered)
  }

  TapHandler {
    acceptedButtons: Qt.LeftButton
    onTapped: root.entry.beginClose(NotificationEntry.Dismissed)
  }

  RowLayout {
    Layout.fillWidth: true
    spacing: root.theme.metrics.capsuleGap

    IconImage {
      source: root.iconSource(root.entry.appIcon)
      implicitSize: root.theme.metrics.notificationIconSize
      Layout.preferredWidth: implicitSize
      Layout.preferredHeight: implicitSize
      Layout.alignment: Qt.AlignTop
    }

    ColumnLayout {
      Layout.fillWidth: true
      spacing: root.theme.metrics.cardContentSpacing / 2

      StyledText {
        text: root.entry.appName
        theme: root.theme
        tone: SemanticRoles.Muted
        textRole: StyledText.Label
        elide: Text.ElideRight
        Layout.fillWidth: true
      }

      StyledText {
        text: root.entry.summary
        visible: text !== ""
        theme: root.theme
        textRole: StyledText.Body
        strong: true
        elide: Text.ElideRight
        Layout.fillWidth: true
      }

      StyledText {
        text: root.entry.body
        visible: text !== ""
        theme: root.theme
        tone: SemanticRoles.Muted
        textRole: StyledText.Body
        wrapMode: Text.Wrap
        maximumLineCount: root.theme.metrics.notificationBodyLineCount
        elide: Text.ElideRight
        Layout.fillWidth: true
      }
    }

    IconButton {
      theme: root.theme
      glyph: root.closeGlyph
      tone: SemanticRoles.Muted
      accessibleName: "Dismiss notification"
      Layout.alignment: Qt.AlignTop
      onActivated: root.entry.beginClose(NotificationEntry.Dismissed)
    }
  }

  function iconSource(icon) {
    if (icon.includes("://"))
      return icon
    if (icon.startsWith("/"))
      return `file://${icon}`
    return Quickshell.iconPath(icon, "dialog-information")
  }
}
