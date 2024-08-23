local wezterm = require("wezterm")

local theme_switcher = require("theme_switcher")

---@diagnostic disable-next-line: unused-local
local legacy_config = {
	automatically_reload_config = true,
	check_for_updates = false,
	-- default_cursor_style = "SteadyBlock",
	-- default_gui_startup_args = {"start", "--", "tmux", "new-session", "-A", "-s", "main"},
	-- default_gui_startup_args = {"ssh", "fencing"},
	enable_tab_bar = false,
	exit_behavior = "Close",
	font = wezterm.font("SauceCodePro Nerd Font"),
	font_size = 14.0,

	hide_tab_bar_if_only_one_tab = true,
	initial_cols = 180,
	initial_rows = 68,
	-- native_macos_fullscreen_mode = true,

	quick_select_patterns = {
		-- match things that look like sha1 hashes
		-- (this is actually one of the default patterns)
		"[0-9a-f]{7,40}",
	},
	-- scroll_to_bottom_on_input = true,
	-- scrollback_lines = 3500,
	selection_word_boundary = ",│`|:\"' ()[]{}<>\t",
	-- show_tab_index_in_tab_bar = false,
	show_update_window = false,

	ssh_domains = {
		{
			name = "fencing",
			multiplexing = "None",
			remote_address = "fencing.leadigital.net",
		},
	},

	tab_bar_at_bottom = true,
	-- tempfile=$(mktemp) \
	-- && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
	-- && tic -x -o ~/.terminfo $tempfile \
	-- && rm $tempfile
	term = "wezterm",
	-- term = "tmux-256color",
	unicode_version = 14,
	use_fancy_tab_bar = false,
	window_close_confirmation = "NeverPrompt",
	-- window_decorations = "NONE",
	window_decorations = "RESIZE",
	window_padding = {
		left = "1cell",
		right = "1cell",
		-- top = "0.5cell",
		-- bottom = "0.5cell"
		top = 0,
		bottom = 0,
	},
}

Colorscheme = "Dracula (Official)"
return {
	color_scheme = Colorscheme,

	keys = {
		{
			key = "k",
			mods = "CMD|ALT",
			action = wezterm.action_callback(function(window, pane)
				theme_switcher.theme_switcher(window, pane)
			end),
		},
	},
}
