import QtQuick
import qs.theme

Translate {
  id: root

  required property Theme theme
  property bool shown: true

  y: shown ? 0 : -theme.metrics.railHeight

  Behavior on y {
    MotionAnimation { theme: root.theme; motionRole: MotionAnimation.Standard }
  }
}
