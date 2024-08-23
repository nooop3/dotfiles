return {
	automatically_reload_config = true,
	check_for_updates = false,
	-- default_cursor_style = "SteadyBlock",
	-- default_gui_startup_args = {"start", "--", "tmux", "new-session", "-A", "-s", "main"},
	-- default_gui_startup_args = {"ssh", "fencing"},
	enable_tab_bar = false,
	exit_behavior = "Close",

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

	-- tempfile=$(mktemp) \
	-- && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/main/termwiz/data/wezterm.terminfo \
	-- && tic -x -o ~/.terminfo $tempfile \
	-- && rm $tempfile
	term = "wezterm",
	-- term = "tmux-256color",
	unicode_version = 14,
	window_close_confirmation = "NeverPrompt",
	-- window_decorations = "NONE",
	window_decorations = "RESIZE",
}
