import QtQuick
import qs.theme

Capsule {
  id: root

  property bool expanded: hover.hovered
  property real collapsedWidth: implicitWidth
  required property real expandedWidth
  required property real expandedHeight
  property int expandedContentTop: theme.metrics.capsuleHeight
  property int expandedContentBottom: theme.metrics.capsulePadding
  property int expandedContentHorizontalPadding: theme.metrics.capsulePadding
  property real contentRevealRatio: theme.metrics.expandedContentRevealRatio
  readonly property bool contentRevealed: expanded && height >= expandedHeight * contentRevealRatio
  readonly property bool hovered: hover.hovered
  property alias headerData: headerLayer.data
  default property alias expandedData: expandedLayer.data

  width: collapsedWidth
  height: theme.metrics.capsuleHeight
  clip: true

  states: [
    State {
      name: "expanded"
      when: root.expanded
      PropertyChanges { target: root; width: root.expandedWidth; height: root.expandedHeight }
    },
    State {
      name: "collapsed"
      when: !root.expanded
      PropertyChanges { target: root; width: root.collapsedWidth; height: root.theme.metrics.capsuleHeight }
    }
  ]

  transitions: [
    Transition {
      from: "collapsed"
      to: "expanded"
      SequentialAnimation {
        MotionAnimation { property: "width"; theme: root.theme; motionRole: MotionAnimation.Short }
        MotionAnimation { property: "height"; theme: root.theme; motionRole: MotionAnimation.Standard }
      }
    },
    Transition {
      from: "expanded"
      to: "collapsed"
      SequentialAnimation {
        MotionAnimation { property: "height"; theme: root.theme; motionRole: MotionAnimation.Short; easing.type: root.theme.motion.spatialIn }
        MotionAnimation { property: "width"; theme: root.theme; motionRole: MotionAnimation.Fast; easing.type: root.theme.motion.spatialIn }
      }
    }
  ]

  Item {
    id: headerLayer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    height: root.theme.metrics.capsuleHeight
  }

  Item {
    id: expandedLayer
    anchors.left: parent.left
    anchors.right: parent.right
    anchors.top: parent.top
    anchors.bottom: parent.bottom
    anchors.topMargin: root.expandedContentTop
    anchors.bottomMargin: root.expandedContentBottom
    anchors.leftMargin: root.expandedContentHorizontalPadding
    anchors.rightMargin: root.expandedContentHorizontalPadding
    opacity: root.contentRevealed ? 1 : 0
    visible: root.expanded

    Behavior on opacity { MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Fast } }
  }

  HoverHandler { id: hover }
}
