import QtQuick

QtObject {
  property bool reducedMotion: false
  readonly property real scale: reducedMotion ? 0 : 1
  readonly property int fast: Math.round(70 * scale)
  readonly property int shortDuration: Math.round(100 * scale)
  readonly property int standard: Math.round(150 * scale)
  readonly property int emphasized: Math.round(200 * scale)
  readonly property int barEnter: Math.round(200 * scale)
  readonly property int spatialOut: Easing.OutCubic
  readonly property int spatialIn: Easing.InCubic
  readonly property int effect: Easing.InOutQuad
}
