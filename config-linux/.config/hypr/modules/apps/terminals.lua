hl.window_rule({
  match = { class = "(Alacritty|kitty|com\\.mitchellh\\.ghostty)" },
  tag = "+terminal",
})

hl.window_rule({
  match = { tag = "terminal" },
  tag = "-default-opacity",
  opacity = "0.97 0.9",
})
