return {
	automatically_reload_config = true,
	-- default_cursor_style = "SteadyBlock",
	-- default_gui_startup_args = {"start", "--", "tmux", "new-session", "-A", "-s", "main"},
	-- default_gui_startup_args = {"ssh", "fencing"},
	exit_behavior = "Close",

	initial_cols = 180,
	initial_rows = 68,

	quick_select_patterns = {
		-- match things that look like sha1 hashes
		-- (this is actually one of the default patterns)
		"[0-9a-f]{7,40}",
	},
	-- scroll_to_bottom_on_input = true,

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
}
