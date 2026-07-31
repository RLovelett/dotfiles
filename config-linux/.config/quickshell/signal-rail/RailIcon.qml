import QtQuick

Text {
  id: root

  required property var theme
  property string glyph: ""
  property color tint: theme.foreground
  property int pointSize: theme.iconSize
  property int slotSize: theme.iconSlotSize

  text: glyph
  color: tint
  width: slotSize
  height: slotSize
  font.family: theme.iconFontFamily
  font.pixelSize: pointSize
  font.weight: Font.Normal
  renderType: Text.NativeRendering
  horizontalAlignment: Text.AlignHCenter
  verticalAlignment: Text.AlignVCenter
}
