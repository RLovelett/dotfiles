hl.window_rule({
  match = { title = "^vigil -" },
  tag = "-floating-window",
  float = true,
  pin = true,
  no_focus = true,
  suppress_event = "activate",
  monitor = "HDMI-A-1",
  size = { "15%", "15%" },
  keep_aspect_ratio = true,
  move = { "monitor_w-window_w-4", "4" },
})
