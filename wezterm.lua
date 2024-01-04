local wezterm = require 'wezterm'
local act = wezterm.action

return {
  color_scheme = "VSCodeDark+ (Gogh)",
  force_reverse_video_cursor = true,
  tab_bar_at_bottom = true,
  font = wezterm.font_with_fallback {
    "Iosevka",
    "JetBrains Mono",
  },
  exit_behavior = "Close",
  window_close_confirmation = "NeverPrompt",
  font_size = 11,
  audible_bell = "Disabled",
  initial_rows = 50,
  initial_cols = 200,
  mouse_bindings = {
    {
      event = { Up = { streak = 2, button = 'Left' } },
      mods = 'NONE',
      action = act.CopyTo 'ClipboardAndPrimarySelection',
    },
    {
      event = { Up = { streak = 1, button = 'Left' } },
      mods = 'NONE',
      action = wezterm.action.CompleteSelectionOrOpenLinkAtMouseCursor 'Clipboard',
    },
  },
  keys = {
    {
      key = "t", mods = "ALT", action = wezterm.action { SpawnTab = "CurrentPaneDomain" }
    },
    {
      key = "s", mods = "ALT", action = wezterm.action { SplitHorizontal = { domain = "CurrentPaneDomain" } }
    },
    {
      key = "s", mods = "ALT|SHIFT", action = wezterm.action { SplitVertical = { domain = "CurrentPaneDomain" } }
    },
    {
      key = "h", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Left" }
    },
    {
      key = "l", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Right" }
    },
    {
      key = "k", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Up" }
    },
    {
      key = "j", mods = "ALT", action = wezterm.action { ActivatePaneDirection = "Down" }
    },
    {
      key = "[", mods = "ALT", action = wezterm.action { ActivateTabRelative = -1 }
    },
    {
      key = "]", mods = "ALT", action = wezterm.action { ActivateTabRelative = 1 }
    },
    {
      key = "1", mods = "ALT", action = wezterm.action { ActivateTab = 0 }
    },
    {
      key = "2", mods = "ALT", action = wezterm.action { ActivateTab = 1 }
    },
    {
      key = "3", mods = "ALT", action = wezterm.action { ActivateTab = 2 }
    },
    {
      key = "4", mods = "ALT", action = wezterm.action { ActivateTab = 3 }
    },
    {
      key = "5", mods = "ALT", action = wezterm.action { ActivateTab = 4 }
    },
    {
      key = "6", mods = "ALT", action = wezterm.action { ActivateTab = 5 }
    },
    {
      key = "7", mods = "ALT", action = wezterm.action { ActivateTab = 6 }
    },
    {
      key = "8", mods = "ALT", action = wezterm.action { ActivateTab = 7 }
    },
    {
      key = "9", mods = "ALT", action = wezterm.action { ActivateTab = 8 }
    },
  },
}
