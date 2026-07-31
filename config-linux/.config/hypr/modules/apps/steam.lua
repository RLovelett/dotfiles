local STEAM = "^([sS]team)$"

-- DRY helper: every rule shares class=STEAM. Pass the extra match props that
-- disambiguate the window, plus the effects to apply.
local function steam_rule(match_extra, effects)
  local rule = { match = { class = STEAM } }
  for k, v in pairs(match_extra) do
    rule.match[k] = v
  end
  for k, v in pairs(effects) do
    rule[k] = v
  end
  hl.window_rule(rule)
end

steam_rule({}, {
  tag = "-default-opacity",
  opacity = "1.0 override 1.0 override",
})

-- Steam's loader maps before WM_CLASS is populated, so this rule also
-- accepts an empty initial class without broadening the other Steam rules.
steam_rule({ title = "^(Steam)$", float = true, class = "^([sS]team)?$" }, {
  center = true,
  no_focus = true,
})

steam_rule({ title = "^$", float = true }, {
  center = true,
  no_focus = true,
})

steam_rule({ title = "^(Sign in to Steam)$" }, {
  float = true,
  center = true,
})

steam_rule({ title = "^(Shutdown)$" }, {
  float = true,
  center = true,
})

steam_rule({ title = "^(Friends List)$" }, {
  float = true,
  size = { "monitor_w*0.14", "monitor_h*0.70" },
  move = { "monitor_w*0.86-8", "8" },
})
