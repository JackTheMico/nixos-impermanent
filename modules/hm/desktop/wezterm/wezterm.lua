local wezterm = require("wezterm")
-- tabline
local tabline = wezterm.plugin.require("https://github.com/michaelbrusegard/tabline.wez")
tabline.setup()
-- smart workspace swither
local workspace_switcher = wezterm.plugin.require("https://github.com/MLFlexer/smart_workspace_switcher.wezterm")
-- wez-pain-control
local wezpaincontrol = wezterm.plugin.require("https://github.com/sei40kr/wez-pain-control")
-- resurrect.wezterm
local resurrect = wezterm.plugin.require("https://github.com/MLFlexer/resurrect.wezterm")

local config = {
  color_scheme = "Catppuccin Macchiato",
  leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 },
  keys = {
    {
      key = "s",
      mods = "ALT",
      action = wezterm.action_callback(function(win, pane)
        resurrect.state_manager.save_state(resurrect.workspace_state.get_workspace_state())
        resurrect.window_state.save_window_action()
      end),
    },
    {
      key = "r",
      mods = "ALT",
      action = wezterm.action_callback(function(win, pane)
        resurrect.fuzzy_loader.fuzzy_load(win, pane, function(id, label)
          local type = string.match(id, "^([^/]+)") -- match before '/'
          id = string.match(id, "([^/]+)$")         -- match after '/'
          id = string.match(id, "(.+)%..+$")        -- remove file extention
          local opts = {
            relative = true,
            restore_text = true,
            on_pane_restore = resurrect.tab_state.default_on_pane_restore,
          }
          if type == "workspace" then
            local state = resurrect.state_manager.load_state(id, "workspace")
            resurrect.workspace_state.restore_workspace(state, opts)
          elseif type == "window" then
            local state = resurrect.state_manager.load_state(id, "window")
            resurrect.window_state.restore_window(pane:window(), state, opts)
          elseif type == "tab" then
            local state = resurrect.state_manager.load_state(id, "tab")
            resurrect.tab_state.restore_tab(pane:tab(), state, opts)
          end
        end)
      end),
    },
  },
  font = wezterm.font("Maple Mono NF", { weight = "Bold", italic = false }),
  font_size = 18,
  hide_tab_bar_if_only_one_tab = true,
  use_fancy_tab_bar = true,
  tab_bar_at_bottom = false,
  -- window_decorations = "RESIZE",
  show_new_tab_button_in_tab_bar = false,
  window_background_opacity = 0.9,
  text_background_opacity = 0.9,
  adjust_window_size_when_changing_font_size = true,
  enable_wayland = true,
  enable_scroll_bar = true,
  window_padding = {
    top = 2,
    right = 2,
    left = 2,
    bottom = 0,
  },
}
workspace_switcher.apply_to_config(config)
wezpaincontrol.apply_to_config(config, {
  pane_resize = 5,
})

-- resurrect.wezterm
resurrect.state_manager.periodic_save({
  interval_seconds = 600,
  save_workspaces = true,
  save_windows = true,
  save_tabs = true,
})
-- Resurrecting on startup
wezterm.on("gui-startup", resurrect.state_manager.resurrect_on_gui_startup)

-- loads the state whenever I create a new workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.created", function(window, path, label)
  local workspace_state = resurrect.workspace_state

  workspace_state.restore_workspace(resurrect.state_manager.load_state(label, "workspace"), {
    window = window,
    relative = true,
    restore_text = true,
    on_pane_restore = resurrect.tab_state.default_on_pane_restore,
  })
end)

-- Saves the state whenever I select a workspace
wezterm.on("smart_workspace_switcher.workspace_switcher.selected", function(window, path, label)
  local workspace_state = resurrect.workspace_state
  resurrect.state_manager.save_state(workspace_state.get_workspace_state())
end)


return config
