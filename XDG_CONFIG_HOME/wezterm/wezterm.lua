local wezterm = require("wezterm")

local utils = require("utils")
local util_sys = require("utils.sys")

local tmux = require("tmux")
local key_tables = require("key-tables")
local session_manager = require("session-manager")
require("events")

local theme_switcher = require("theme-switcher")

local act = wezterm.action

Colorscheme = "3024 (base16)"

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
config.font_size = util_sys.is_darwin and 14.0 or 8.0
config.command_palette_font_size = util_sys.is_darwin and 16.0 or 10.0
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
-- config.initial_cols = 180
-- config.initial_rows = 68
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
config.enable_wayland = util_sys.is_linux and false
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

	{
		key = ",",
		mods = "SUPER",
		action = wezterm.action.SpawnCommandInNewTab({
			cwd = wezterm.home_dir,
			args = {
				util_sys.is_darwin and "/opt/homebrew/bin/nvim" or "nvim",
				wezterm.config_file,
			},
		}),
	},

	--[[ {
		key = "l",
		mods = "CTRL",
		---@diagnostic disable-next-line: unused-local
		action = wezterm.action_callback(function(window, pane)
			local pos = pane:get_cursor_position()
			-- local move_viewport_to_scrollback = string.rep("\r\n", pos.y)
			local dims = pane:get_dimensions()
			local move_viewport_to_scrollback = string.rep("\r\n", pos.y - dims.physical_top)
			pane:inject_output(move_viewport_to_scrollback)
			-- pane:send_text("\x0c") -- CTRL-L
		end),
	}, ]]
}

utils.table.merge_table(keys, tmux.keys)
utils.table.merge_table(keys, session_manager.keys)
config.keys = keys

config.key_tables = key_tables

return config
