import QtQuick

QtObject {
  readonly property color background: "#282a36"
  readonly property color backgroundDim: "#282a36dd"
  readonly property color surface: "#4d282a36"
  readonly property color selection: "#44475a"
  readonly property color foreground: "#f8f8f2"
  readonly property color foregroundMuted: "#d8d8df"
  readonly property color comment: "#6272a4"
  readonly property color red: "#ff5555"
  readonly property color orange: "#ffb86c"
  readonly property color yellow: "#f1fa8c"
  readonly property color green: "#50fa7b"
  readonly property color purple: "#bd93f9"
  readonly property color cyan: "#8be9fd"
  readonly property color pink: "#ff79c6"
  readonly property color shadow: "#1e202966"

  readonly property color capsuleOutline: selection
  readonly property color capsuleOutlineStrong: cyan
  readonly property color capsuleOutlineAccent: purple
  readonly property color capsuleOutlineRight: pink
  readonly property color capsuleFill: surface
  readonly property color separator: selection
  readonly property color track: selection
  readonly property color trackMuted: comment
  readonly property color activeFill: cyan
  readonly property color activeText: background
  readonly property color inactiveFill: background
  readonly property color inactiveText: foregroundMuted

  readonly property int capsuleHeight: 32
  readonly property int capsuleTopMargin: 8
  readonly property int capsuleHorizontalMargin: 20
  readonly property int capsuleInnerPadX: 12
  readonly property int capsuleGap: 12
  // Hyprland gaps_out is 8px; reserve only the capsule's 32px plus its 8px top gap.
  readonly property int railHeight: 40
  readonly property int railLineTopMargin: 24
  // Caelestia's Material Symbols medium token is 24 / 1.33 ≈ 18px.
  readonly property int iconSize: 18
  readonly property int iconSlotSize: 24
  readonly property string iconFontFamily: "Material Symbols Rounded"
  readonly property int clockIconSize: 18
  readonly property int clockHeaderHeight: 22
}
