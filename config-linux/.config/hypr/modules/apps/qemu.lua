hl.window_rule({
  match = { class = "qemu" },
  tag = "-default-opacity",
  opacity = "1 1",
})

hl.window_rule({
  match = { class = "^(xfreerdp)$" },
  workspace = "9 silent",
  fullscreen = true,
})

hl.window_rule({
  match = { class = "^(looking-glass-client)$" },
  workspace = "10 silent",
  fullscreen = true,
})
