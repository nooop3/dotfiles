-- Pull in the wezterm API
local wezterm = require("wezterm")

local theme_switcher = require("theme-switcher")

local act = wezterm.action
local mux = wezterm.mux

-- https://github.com/wez/wezterm/discussions/4728
local is_darwin = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

Colorscheme = "Dracula (Official)"

-- --------------------------------------------------------------------
-- CONFIGURATION
-- --------------------------------------------------------------------
local config = wezterm.config_builder()

-- appearance
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
-- config.native_macos_fullscreen_mode = true
config.window_decorations = "RESIZE"
config.window_padding = {
	left = 0,
	right = 0,
	top = 0,
	bottom = 0,
}

-- bell
config.audible_bell = "Disabled"

-- color
config.color_scheme = Colorscheme

-- mouse
config.mouse_wheel_scrolls_tabs = true
config.pane_focus_follows_mouse = false
config.selection_word_boundary = ",│`|:\"' ()[]{}<>\t"
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true

-- tag_bar
config.enable_tab_bar = true
-- config.show_close_tab_button_in_tabs = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.show_tabs_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_and_split_indices_are_zero_based = false
config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.use_fancy_tab_bar = false

-- updates
config.check_for_updates = false
config.show_update_window = false

-- TODO: review
config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"SauceCodePro Nerd Font",
	"JetBrains Mono",
})
config.font_size = is_darwin and 13.0 or 8.0

config.enable_wayland = is_linux and false
config.use_ime = true

-- tmux like config
config.scrollback_lines = 50000
config.leader = {
	key = "b",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}
config.unix_domains = {
	{
		name = "unix",
	},
}

-- config.automatically_reload_config = true
-- config.enable_scroll_bar = true
-- config.mouse_bindings = {
-- 	-- Open URLs with Ctrl+Click
-- 	{
-- 		event = { Up = { streak = 1, button = "Left" } },
-- 		mods = "CTRL",
-- 		action = act.OpenLinkAtMouseCursor,
-- 	},
-- }
-- config.scrollback_lines = 5000
-- config.use_dead_keys = false
-- config.warn_about_missing_glyphs = false

-- key bindings
local function merge_table(table1, table2)
	for _, value in ipairs(table2) do
		table1[#table1 + 1] = value
	end
	return table1
end

-- Custom key bindings
local keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{ key = "m", mods = "CMD", action = act.DisableDefaultAssignment },

	{ key = "k", mods = "CMD|ALT", action = wezterm.action_callback(function(window, pane)
		theme_switcher.theme_switcher(window, pane)
	end) },

	-- tmux-like keybindings
	-- Attach to muxer
	{ key = "a", mods = "LEADER", action = act.AttachDomain("unix") },
	-- Detach from muxer
	{ key = "d", mods = "LEADER", action = act.DetachDomain({ DomainName = "unix" }) },
	-- Rename current session; analagous to command in tmux
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session",
			---@diagnostic disable-next-line: unused-local
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},
	-- Show list of workspaces
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "WORKSPACES" }) },

	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			---@diagnostic disable-next-line: unused-local
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	{ key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	-- { key = "|", mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Right", size = { Percent = 50 } }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	-- { key = "-", mods = "LEADER", action = act.SplitPane({ direction = "Down", size = { Percent = 50 } }) },
	{ key = "q", mods = "LEADER", action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
	{ key = ";", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
	{ key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },

	{ key = "S", mods = "LEADER", action = wezterm.action({ EmitEvent = "save_session" }) },
	{ key = "L", mods = "LEADER", action = wezterm.action({ EmitEvent = "load_session" }) },
	{ key = "R", mods = "LEADER", action = wezterm.action({ EmitEvent = "restore_session" }) },

	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = "b", mods = "LEADER|CTRL", action = act.SendKey({ key = "b", mods = "CTRL" }) },
	-- -- Disable Alt-Enter combination (already used in tmux to split pane)
	-- {
	--     key = 'Enter',
	--     mods = 'ALT',
	--     action = act.DisableDefaultAssignment,
	-- },

	-- Copy mode
	{
		key = "[",
		mods = "LEADER",
		action = act.ActivateCopyMode,
	},

	-- ----------------------------------------------------------------
	-- TABS
	--
	-- Where possible, I'm using the same combinations as I would in tmux
	-- ----------------------------------------------------------------

	-- Show tab navigator; similar to listing panes in tmux
	{
		key = "w",
		mods = "LEADER",
		action = act.ShowTabNavigator,
	},
	-- Create a tab (alternative to Ctrl-Shift-Tab)
	{
		key = "c",
		mods = "LEADER",
		action = act.SpawnTab("CurrentPaneDomain"),
	},
	-- Rename current tab; analagous to command in tmux
	{
		key = ",",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			---@diagnostic disable-next-line: unused-local
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},
	-- Move to next/previous TAB
	{
		key = "n",
		mods = "LEADER",
		action = act.ActivateTabRelative(1),
	},
	{
		key = "p",
		mods = "LEADER",
		action = act.ActivateTabRelative(-1),
	},
	-- Close tab
	{
		key = "&",
		mods = "LEADER|SHIFT",
		action = act.CloseCurrentTab({ confirm = true }),
	},

	-- ----------------------------------------------------------------
	-- PANES
	--
	-- These are great and get me most of the way to replacing tmux
	-- entirely, particularly as you can use "wezterm ssh" to ssh to another
	-- server, and still retain Wezterm as your terminal there.
	-- ----------------------------------------------------------------

	-- -- Vertical split
	{
		-- |
		key = "|",
		mods = "LEADER|SHIFT",
		action = act.SplitPane({
			direction = "Right",
			size = { Percent = 50 },
		}),
	},
	-- Horizontal split
	{
		-- -
		key = "-",
		mods = "LEADER",
		action = act.SplitPane({
			direction = "Down",
			size = { Percent = 50 },
		}),
	},
	--[[ -- CTRL + (h,j,k,l) to move between panes
	{
		key = "h",
		mods = "CTRL",
		action = act({ EmitEvent = "move-left" }),
	},
	{
		key = "j",
		mods = "CTRL",
		action = act({ EmitEvent = "move-down" }),
	},
	{
		key = "k",
		mods = "CTRL",
		action = act({ EmitEvent = "move-up" }),
	},
	{
		key = "l",
		mods = "CTRL",
		action = act({ EmitEvent = "move-right" }),
	},
	-- ALT + (h,j,k,l) to resize panes
	{
		key = "h",
		mods = "ALT",
		action = act({ EmitEvent = "resize-left" }),
	},
	{
		key = "j",
		mods = "ALT",
		action = act({ EmitEvent = "resize-down" }),
	},
	{
		key = "k",
		mods = "ALT",
		action = act({ EmitEvent = "resize-up" }),
	},
	{
		key = "l",
		mods = "ALT",
		action = act({ EmitEvent = "resize-right" }),
	}, ]]
	-- Close/kill active pane
	{
		key = "x",
		mods = "LEADER",
		action = act.CloseCurrentPane({ confirm = true }),
	},
	-- Swap active pane with another one
	{
		key = "{",
		mods = "LEADER|SHIFT",
		action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
	},
	-- Zoom current pane (toggle)
	{
		key = "z",
		mods = "LEADER",
		action = act.TogglePaneZoomState,
	},
	{
		key = "f",
		mods = "ALT",
		action = act.TogglePaneZoomState,
	},
	-- Move to next/previous pane
	{
		key = ";",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Prev"),
	},
	{
		key = "o",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Next"),
	},

	-- ----------------------------------------------------------------
	-- Workspaces
	--
	-- These are roughly equivalent to tmux sessions.
	-- ----------------------------------------------------------------

	-- Attach to muxer
	{
		key = "a",
		mods = "LEADER",
		action = act.AttachDomain("unix"),
	},

	-- Detach from muxer
	{
		key = "d",
		mods = "LEADER",
		action = act.DetachDomain({ DomainName = "unix" }),
	},

	-- Show list of workspaces
	{
		key = "s",
		mods = "LEADER",
		action = act.ShowLauncherArgs({ flags = "WORKSPACES" }),
	},
	-- Rename current session; analagous to command in tmux
	{
		key = "$",
		mods = "LEADER|SHIFT",
		action = act.PromptInputLine({
			description = "Enter new name for session",
			---@diagnostic disable-next-line: unused-local
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					mux.rename_workspace(window:mux_window():get_workspace(), line)
				end
			end),
		}),
	},

	-- Session manager bindings
	{
		key = "s",
		mods = "LEADER|SHIFT",
		action = act({ EmitEvent = "save_session" }),
	},
	{
		key = "L",
		mods = "LEADER|SHIFT",
		action = act({ EmitEvent = "load_session" }),
	},
	{
		key = "R",
		mods = "LEADER|SHIFT",
		action = act({ EmitEvent = "restore_session" }),
	},
}

local tmux_activate_tab_keys = {}
for i = 1, 9 do
	table.insert(tmux_activate_tab_keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end
merge_table(keys, tmux_activate_tab_keys)

config.keys = keys

return config
