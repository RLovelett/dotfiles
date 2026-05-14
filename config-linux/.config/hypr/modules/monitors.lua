-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and resolutions possible: hyprctl monitors

-- Explicit monitor layout: DP-2 (left), HDMI-A-1 (right)
hl.monitor({
  output = "DP-2",
  mode = "preferred",
  position = "0x0",
  scale = "1.25",
  bitdepth = 10,
  vrr = 1,
})

hl.monitor({
  output = "HDMI-A-1",
  mode = "preferred",
  position = "auto-right",
  scale = "1.25",
  bitdepth = 10,
})

-- Catch-all for any other connected displays
hl.monitor({
  output = "",
  mode = "preferred",
  position = "auto",
  scale = "1.25",
  bitdepth = 10,
  vrr = 1,
})
