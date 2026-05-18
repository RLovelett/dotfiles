local animations = {
  -- Windows
  { leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" },
  { leaf = "windowsIn", enabled = true, speed = 5, bezier = "overshot", style = "popin 80%" },
  { leaf = "windowsOut", enabled = true, speed = 4, bezier = "smoothOut", style = "popin 95%" },
  { leaf = "windowsMove", enabled = true, speed = 4, bezier = "softSnap" },
  -- Layers
  { leaf = "layersIn", enabled = true, speed = 3, bezier = "smoothIn", style = "slide right" },
  { leaf = "layersOut", enabled = true, speed = 2, bezier = "softSnap", style = "slide right" },
  -- Fade
  { leaf = "fade", enabled = true, speed = 4, bezier = "smoothIn" },
  { leaf = "fadeIn", enabled = true, speed = 4, bezier = "smoothIn" },
  { leaf = "fadeOut", enabled = true, speed = 4, bezier = "smoothOut" },
  { leaf = "fadeSwitch", enabled = true, speed = 4, bezier = "smoothIn" },
  { leaf = "fadeShadow", enabled = true, speed = 4, bezier = "smoothIn" },
  { leaf = "fadeDim", enabled = true, speed = 4, bezier = "smoothIn" },
  { leaf = "fadeDpms", enabled = true, speed = 4, bezier = "smoothIn" },
  -- Workspaces
  { leaf = "workspaces", enabled = true, speed = 5, bezier = "overshot", style = "slidefade 30%" },
  { leaf = "specialWorkspace", enabled = true, speed = 5, bezier = "overshot", style = "slidefadevert 30%" },
}

for _, anim in ipairs(animations) do
  hl.animation(anim)
end
