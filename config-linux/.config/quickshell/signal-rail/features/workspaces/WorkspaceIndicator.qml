import QtQuick
import qs.components
import qs.theme

InteractiveItem {
  id: root

  required property string label
  property bool active: false
  property bool focused: false
  property bool urgent: false
  property bool special: false

  implicitWidth: theme.metrics.workspaceSlotSize
  implicitHeight: theme.metrics.capsuleHeight
  accessibleName: special ? "Scratchpad workspace" : `Workspace ${label}`

  // Active is per monitor; focused identifies the one monitor receiving input.
  // Urgency is orthogonal, so it replaces only the outline, never the active fill.
  readonly property color fillColor: special
    ? active ? theme.colors.special : theme.colors.transparent
    : active
      ? focused ? theme.colors.activeFocused : theme.colors.activeUnfocused
      : theme.colors.transparent
  readonly property color outlineColor: urgent
    ? theme.colors.attention
    : special
      ? theme.colors.special
      : active
        ? fillColor
        : theme.colors.outline
  readonly property int labelTone: urgent && !active
    ? SemanticRoles.Warning
    : special && !active
      ? SemanticRoles.Secondary
      : active && focused
        ? SemanticRoles.OnAccent
        : SemanticRoles.Normal

  Rectangle {
    id: circle
    anchors.centerIn: parent
    width: root.theme.metrics.workspaceCircleSize
    height: width
    radius: width / 2
    color: root.fillColor
    border.width: root.theme.metrics.capsuleBorderWidth
    border.color: root.outlineColor

    StyledText {
      anchors.fill: parent
      text: root.label
      tone: root.labelTone
      theme: root.theme
      textRole: StyledText.Label
      strong: root.focused
      horizontalAlignment: Text.AlignHCenter
      verticalAlignment: Text.AlignVCenter
    }

    SequentialAnimation {
      id: attentionPulse
      MotionAnimation {
        target: circle
        property: "scale"
        to: root.theme.metrics.attentionScale
        theme: root.theme
        motionRole: MotionAnimation.Short
      }
      MotionAnimation {
        target: circle
        property: "scale"
        to: 1
        theme: root.theme
        motionRole: MotionAnimation.Standard
      }
    }
  }

  onUrgentChanged: if (urgent) attentionPulse.restart()

  scale: hovered ? theme.metrics.hoverScale : 1
  Behavior on scale {
    MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Short }
  }
}
