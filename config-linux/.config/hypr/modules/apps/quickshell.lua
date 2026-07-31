hl.layer_rule({
  match = { namespace = "quickshell" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
})

-- Signal Rail uses distinct namespaces so its visual layers can animate
-- independently. Only the interactive bar surface contains translucent UI.
hl.layer_rule({
  match = { namespace = "signal-rail-bar" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
  no_anim = true,
})

-- Notification cards share the glass treatment, but Quickshell owns their
-- vertical lifecycle and stack animations.
hl.layer_rule({
  match = { namespace = "signal-rail-notifications" },
  blur = true,
  blur_popups = true,
  ignore_alpha = 0.2,
  no_anim = true,
})

-- Structural surfaces must not inherit the global horizontal layer motion.
hl.layer_rule({
  match = { namespace = "signal-rail-(track|reservation)" },
  no_anim = true,
})
