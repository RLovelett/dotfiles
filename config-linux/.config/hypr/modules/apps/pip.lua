hl.window_rule({
  match = { title = "(Picture.?in.?[Pp]icture)" },
  tag = "+pip",
})

hl.window_rule({
  match = { tag = "pip" },
  tag = "-default-opacity",
  float = true,
  pin = true,
  max_size = { 1920, 1080 },
  min_size = { 960, 540 },
  keep_aspect_ratio = true,
  border_size = 0,
  opacity = "1 1",
  move = { "monitor_w-window_w-8", "monitor_h-window_h-8" },
})
