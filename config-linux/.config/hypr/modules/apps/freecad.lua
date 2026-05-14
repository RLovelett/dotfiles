-- FreeCAD window rules
local freecad = "^(org\\.freecad\\.FreeCAD)$"
hl.window_rule({
  match = { class = freecad, title = "^(Welcome)$" },
  float = true,
  size = { 1000, 700 },
})

local freecad_dialogs = {
  "^(Preferences)$",
  "^(About FreeCAD)$",
  "^(Addon manager)$",
  "^(.*Properties.*)$",
  "^(Select.*)$",
  "^(Save.*)$",
  "^(Open.*)$",
  "^(Export.*)$",
  "^(Import.*)$",
}

for _, title in ipairs(freecad_dialogs) do
  hl.window_rule({
    match = { class = freecad, title = title },
    float = true,
  })
end

hl.window_rule({
  match = { class = freecad, float = true },
  center = true,
})
