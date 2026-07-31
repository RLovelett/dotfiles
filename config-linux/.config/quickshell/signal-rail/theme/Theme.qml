import QtQuick

QtObject {
  id: root

  property bool reducedMotion: false
  property ColorTokens colors: ColorTokens {}
  property var palette: colors.palette
  property TypographyTokens type: TypographyTokens {}
  property MetricTokens metrics: MetricTokens {}
  property MotionTokens motion: MotionTokens { reducedMotion: root.reducedMotion }
}
