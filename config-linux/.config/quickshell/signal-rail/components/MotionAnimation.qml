import QtQuick
import qs.theme

NumberAnimation {
  enum MotionRole { Fast, Short, Standard, Emphasized }

  required property Theme theme
  property int motionRole: MotionAnimation.Standard

  duration: motionRole === MotionAnimation.Fast
    ? theme.motion.fast
    : motionRole === MotionAnimation.Short
      ? theme.motion.shortDuration
      : motionRole === MotionAnimation.Emphasized
        ? theme.motion.emphasized
        : theme.motion.standard
  easing.type: theme.motion.spatialOut
}
