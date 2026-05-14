local backgroundRaw = "282A36"
local selectionRaw = "44475A"
local colors = {
  background = "rgb(" .. backgroundRaw .. ")",
  backgroundRaw = backgroundRaw,
  background_dim = "rgba(" .. backgroundRaw .. "dd)",
  foreground = "rgb(F8F8F2)",
  foregroundRaw = "F8F8F2",
  selection = "rgb(" .. selectionRaw .. ")",
  selectionRaw = selectionRaw,
  selection_translucent = "rgba(" .. selectionRaw .. "aa)",
  comment = "rgb(6272A4)",
  commentRaw = "6272A4",
  red = "rgb(FF5555)",
  redRaw = "FF5555",
  orange = "rgb(FFB86C)",
  orangeRaw = "FFB86C",
  yellow = "rgb(F1FA8C)",
  yellowRaw = "F1FA8C",
  green = "rgb(50FA7B)",
  greenRaw = "50FA7B",
  purple = "rgb(BD93F9)",
  purpleRaw = "BD93F9",
  cyan = "rgb(8BE9FD)",
  cyanRaw = "8BE9FD",
  pink = "rgb(FF79C6)",
  pinkRaw = "FF79C6",
  shadow = "rgba(1E202966)",
}

-- Handle aliases
colors.accent = colors.purple
colors.accentRaw = colors.purpleRaw

return colors
