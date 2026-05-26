local animations = {
  -- Windows
  { leaf = "windows", enabled = true, speed = 5, bezier = "overshot", style = "slide" },
  { leaf = "windowsIn", enabled = true, speed = 2, bezier = "overshot", style = "slide" },
  { leaf = "windowsOut", enabled = true, speed = 1, bezier = "smoothOut", style = "slide" },
  { leaf = "windowsMove", enabled = true, speed = 3, bezier = "softSnap" },
  -- Layers
  { leaf = "layersIn", enabled = true, speed = 5, spring = "spring_relaxed", style = "slide right" },
  { leaf = "layersOut", enabled = true, speed = 5, spring = "spring_relaxed", style = "slide right" },
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
