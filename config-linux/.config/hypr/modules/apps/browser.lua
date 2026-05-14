-- Browser types
hl.window_rule({
  match = { class = "((google-)?[cC]hrom(e|ium)|[bB]rave-browser|[mM]icrosoft-edge|Vivaldi-stable|helium)" },
  tag = "+chromium-based-browser",
})
hl.window_rule({
  match = { class = "([fF]irefox|zen|librewolf)" },
  tag = "+firefox-based-browser",
})

-- Chromium: drop default-opacity tag, force tile, full opacity
hl.window_rule({
  match = { tag = "chromium-based-browser" },
  tag = "-default-opacity",
  tile = true,
  opacity = "1.0 1.0",
})

-- Firefox: drop default-opacity tag, full opacity
hl.window_rule({
  match = { tag = "firefox-based-browser" },
  tag = "-default-opacity",
  opacity = "1.0 1.0",
})

-- Video apps: two tag effects, must stay separate
hl.window_rule({
  match = { class = "(chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)" },
  tag = "-chromium-based-browser",
})
hl.window_rule({
  match = { class = "(chrome-youtube.com__-Default|chrome-app.zoom.us__wc_home-Default)" },
  tag = "-default-opacity",
})
