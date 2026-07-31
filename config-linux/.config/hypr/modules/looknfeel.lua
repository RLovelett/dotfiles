require("modules.curves")
require("modules.animations")

local colors = require("modules.colors")
local active_border_color = {
  colors = { "rgba(" .. colors.purpleRaw .. "ee)", "rgba(" .. colors.pinkRaw .. "ee)" },
  angle = 45,
}
local inactive_border_color = colors.selection_translucent

hl.config({
  -- https://wiki.hypr.land/Configuring/Basics/Variables/#general
  general = {
    gaps_in = 4,
    gaps_out = 8,

    border_size = 2,

    col = {
      active_border = colors.purple,
      inactive_border = colors.selection_translucent,
      nogroup_border = colors.background_dim,
      nogroup_border_active = colors.purple,
    },

    -- Set to true enable resizing windows by clicking and dragging on borders and gaps
    resize_on_border = true,
    extend_border_grab_area = 15,
    hover_icon_on_border = true,

    -- Please see https://wiki.hypr.land/Configuring/Advanced-and-Cool/Tearing
    -- before you turn this on
    allow_tearing = false,

    layout = "dwindle",
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
  decoration = {
    rounding = 10,
    rounding_power = 2,

    active_opacity = 1.0,
    inactive_opacity = 1.0,
    fullscreen_opacity = 1.0,

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#blur
    blur = {
      enabled = true,
      size = 10,
      passes = 3,
      ignore_opacity = true,

      noise = 0.08,
      contrast = 1.5,

      xray = false,
      new_optimizations = true,
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#shadow
    shadow = {
      enabled = true,
      range = 60,
      render_power = 3,
      color = colors.shadow,
      offset = { 1, 2 },
      scale = 0.97,
    },

    -- https://wiki.hypr.land/Configuring/Basics/Variables/#glow
    glow = {
      enabled = false,
    },
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
  animations = {
    enabled = true,
    workspace_wraparound = true,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#group
  group = {
    col = {
      border_active = active_border_color,
      border_inactive = inactive_border_color,
      border_locked_active = active_border_color,
      border_locked_inactive = inactive_border_color,
    },
    groupbar = {
      font_size = 12,
      font_family = "monospace",
      font_weight_active = "ultraheavy",
      font_weight_inactive = "normal",

      indicator_height = 0,
      indicator_gap = 5,
      height = 22,
      gaps_in = 5,
      gaps_out = 0,

      text_color = colors.foreground,
      text_color_inactive = "rgba(" .. colors.foregroundRaw .. "90)",
      col = {
        active = "rgba(" .. colors.backgroundRaw .. "40)",
        inactive = "rgba(" .. colors.backgroundRaw .. "20)",
      },

      gradients = true,
      gradient_rounding = 0,
      gradient_round_only_edges = false,
    },
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#misc
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    layers_hog_keyboard_focus = true,
    focus_on_activate = true,
    anr_missed_pings = 3,
    on_focus_under_fullscreen = 1,
    force_default_wallpaper = 0, -- Set to 0 or 1 to disable the anime mascot wallpapers
    mouse_move_enables_dpms = true,
    key_press_enables_dpms = true,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#binds
  binds = {
    hide_special_on_workspace_change = true,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#xwayland
  xwayland = {
    force_zero_scaling = true,
    use_nearest_neighbor = false,
    enabled = true,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#cursor
  cursor = {
    hide_on_key_press = true,
    warp_on_change_workspace = 1,
  },

  -- https://wiki.hypr.land/Configuring/Basics/Variables/#debug
  debug = {
    vfr = true,
    overlay = false,
  },

  -- https://wiki.hypr.land/Configuring/Layouts/Dwindle-Layout/
  dwindle = {
    preserve_split = true,
    force_split = 2,
  },

  -- https://wiki.hypr.land/Configuring/Layouts/Master-Layout/
  master = {
    new_status = "master",
  },
})
