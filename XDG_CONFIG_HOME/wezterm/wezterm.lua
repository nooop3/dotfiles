local wezterm = require("wezterm")

local utils = require("utils")

local tmux = require("tmux")
local session_manager = require("session-manager")

local theme_switcher = require("theme-switcher")

local act = wezterm.action

-- https://github.com/wez/wezterm/discussions/4728
local is_darwin = wezterm.target_triple:find("darwin") ~= nil
local is_linux = wezterm.target_triple:find("linux") ~= nil

Colorscheme = "AyuDark (Gogh)"

-- --------------------------------------------------------------------
-- CONFIGURATION
-- --------------------------------------------------------------------
local config = wezterm.config_builder()

-- appearance
-- config.default_cursor_style = "BlinkingBlock"
-- config.force_reverse_video_cursor = true
config.hide_mouse_cursor_when_typing = true
config.hide_tab_bar_if_only_one_tab = true
-- config.native_macos_fullscreen_mode = true
config.inactive_pane_hsb = {
	saturation = 1.0,
	brightness = 1.0,
}
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

-- debug
-- config.debug_key_events = true

-- event
wezterm.on("update-status", function(window)
	local date = wezterm.strftime("%a %b %-d %H:%M ")
	window:set_right_status(wezterm.format({
		{
			Text = table.concat({
				window:active_workspace(),
				wezterm.nerdfonts.fa_clock_o,
				date,
			}, " "),
		},
	}))

	-- Show which key table is active in the status area
	local key_table = window:active_key_table()
	if key_table then
		key_table = key_table:gsub("^%l", string.upper):gsub("_", " ")
		-- key_table = string.gsub(" " .. key_table, "%W%l", string.upper):sub(2):gsub("_", " ")
		window:set_left_status(wezterm.nerdfonts.md_keyboard .. " " .. key_table .. " ")
	else
		window:set_left_status("")
	end
end)

-- exit_behavior
config.exit_behavior = "Close"
config.window_close_confirmation = "NeverPrompt"

-- font
config.adjust_window_size_when_changing_font_size = false
config.font = wezterm.font_with_fallback({
	"FiraCode Nerd Font",
	"SauceCodePro Nerd Font",
	"JetBrains Mono",
})
config.font_size = is_darwin and 14.0 or 8.0
config.command_palette_font_size = is_darwin and 16.0 or 10.0
-- config.harfbuzz_features = { "zero" }
config.warn_about_missing_glyphs = true

-- mouse
-- config.disable_default_mouse_bindings = true
config.mouse_wheel_scrolls_tabs = true
config.pane_focus_follows_mouse = false
config.selection_word_boundary = ",│`|:\"' ()[]{}<>\t"
config.swallow_mouse_click_on_pane_focus = true
config.swallow_mouse_click_on_window_focus = true
config.mouse_bindings = {
	-- Open URLs with Ctrl+Click
	{
		event = { Up = { streak = 1, button = "Left" } },
		mods = "CTRL",
		action = act.OpenLinkAtMouseCursor,
	},
}

-- multiplexing
config.default_domain = "unix"
config.default_mux_server_domain = "local"
config.default_workspace = "main"
-- config.default_gui_startup_args = {"start", "--", "tmux", "new-session", "-A", "-s", "main"}
-- config.default_gui_startup_args = { "connect", "unix" }
config.unix_domains = {
	{
		name = "unix",
	},
}

-- quick_select
-- config.disable_default_quick_select_patterns = true
config.quick_select_patterns = {
	-- match things that look like sha1 hashes
	-- (this is actually one of the default patterns)
	"[0-9a-f]{7,40}",
}

-- reload
config.automatically_reload_config = true

-- scroll_bar
config.enable_scroll_bar = false
config.scrollback_lines = 50000

-- spawn
config.initial_cols = 180
config.initial_rows = 68
config.prefer_to_spawn_tabs = true

-- tag_bar
config.enable_tab_bar = true
-- config.show_close_tab_button_in_tabs = true
config.show_new_tab_button_in_tab_bar = false
config.show_tab_index_in_tab_bar = true
config.show_tabs_in_tab_bar = true
config.switch_to_last_active_tab_when_closing_tab = true
config.tab_and_split_indices_are_zero_based = false
-- config.tab_bar_at_bottom = true
config.tab_max_width = 32
config.use_fancy_tab_bar = false

-- unicode
config.treat_east_asian_ambiguous_width_as_wide = false
config.unicode_version = 14

-- updates
config.check_for_updates = false
config.show_update_window = false

for _, gpu in ipairs(wezterm.gui.enumerate_gpus()) do
	if gpu.backend == "Vulkan" and gpu.device_type == "IntegratedGpu" then
		config.webgpu_preferred_adapter = gpu
		config.front_end = "WebGpu"
		-- config.webgpu_power_preference = "HighPerformance"
		-- config.webgpu_force_fallback_adapter = true
		break
	end
end
-- tempfile=$(mktemp) \
-- && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
-- && tic -x -o ~/.terminfo $tempfile \
-- && rm $tempfile
-- config.term = "wezterm"
-- config.term = "tmux-256color",
config.enable_wayland = is_linux and false
config.use_dead_keys = false

-- keys
config.use_ime = true
-- config.enable_csi_u_key_encoding = true
-- config.enable_kitty_keyboard = true
-- config.disable_default_key_bindings = true
config.key_map_preference = "Mapped"
config.leader = {
	key = "b",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

-- Custom key bindings
local keys = {
	-- Turn off the default CMD-m Hide action, allowing CMD-m to
	-- be potentially recognized and handled by the tab
	{ key = "m", mods = "CMD", action = act.DisableDefaultAssignment },

	{ key = "k", mods = "CMD|ALT", action = wezterm.action_callback(function(window, pane)
		theme_switcher.theme_switcher(window, pane)
	end) },

	{ key = "Space", mods = "LEADER", action = act.QuickSelect },

	-- tmux-like keybindings
	-- Attach to muxer
	{ key = "a", mods = "LEADER", action = act.AttachDomain("unix") },

	{ key = "v", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "h", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

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
}

utils.table.merge_table(keys, tmux.keys)
utils.table.merge_table(keys, session_manager.keys)

config.keys = keys

config.key_tables = {
	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		{ key = "LeftArrow", action = act.AdjustPaneSize({ "Left", 1 }) },
		{ key = "h", action = act.AdjustPaneSize({ "Left", 1 }) },

		{ key = "RightArrow", action = act.AdjustPaneSize({ "Right", 1 }) },
		{ key = "l", action = act.AdjustPaneSize({ "Right", 1 }) },

		{ key = "UpArrow", action = act.AdjustPaneSize({ "Up", 1 }) },
		{ key = "k", action = act.AdjustPaneSize({ "Up", 1 }) },

		{ key = "DownArrow", action = act.AdjustPaneSize({ "Down", 1 }) },
		{ key = "j", action = act.AdjustPaneSize({ "Down", 1 }) },

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		{ key = "LeftArrow", action = act.ActivatePaneDirection("Left") },
		{ key = "h", action = act.ActivatePaneDirection("Left") },

		{ key = "RightArrow", action = act.ActivatePaneDirection("Right") },
		{ key = "l", action = act.ActivatePaneDirection("Right") },

		{ key = "UpArrow", action = act.ActivatePaneDirection("Up") },
		{ key = "k", action = act.ActivatePaneDirection("Up") },

		{ key = "DownArrow", action = act.ActivatePaneDirection("Down") },
		{ key = "j", action = act.ActivatePaneDirection("Down") },
	},
}

return config
