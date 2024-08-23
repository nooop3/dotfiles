local wezterm = require("wezterm")
local act = wezterm.action

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

Colorscheme = "Dracula (Official)"

return {
	color_scheme = Colorscheme,

	font = wezterm.font_with_fallback({
		"FiraCode Nerd Font",
		"SauceCodePro Nerd Font",
		"JetBrains Mono",
	}),
	font_size = 14.0,

	-- tmux like config
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	tab_max_width = 32,
	switch_to_last_active_tab_when_closing_tab = true,
	pane_focus_follows_mouse = true,
	scrollback_lines = 5000,
	window_padding = {
		left = 0,
		right = 0,
		top = 0,
		bottom = 0,
	},
	leader = {
		key = "b",
		mods = "CTRL",
		timeout_milliseconds = 2000,
	},
	keys = {
		-- Turn off the default CMD-m Hide action, allowing CMD-m to
		-- be potentially recognized and handled by the tab
		{
			key = "m",
			mods = "CMD",
			action = act.DisableDefaultAssignment,
		},

		{
			key = "k",
			mods = "CMD|ALT",
			action = wezterm.action_callback(function(window, pane)
				theme_switcher.theme_switcher(window, pane)
			end),
		},

		-- tmux-like keybindings
		{
			key = "[",
			mods = "LEADER",
			action = act.ActivateCopyMode,
		},
		{
			key = "z",
			mods = "LEADER",
			action = act.TogglePaneZoomState,
		},
		{
			key = "c",
			mods = "LEADER",
			action = act.SpawnTab("CurrentPaneDomain"),
		},
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
		{
			key = "w",
			mods = "LEADER",
			action = act.ShowTabNavigator,
		},
		{
			key = "&",
			mods = "LEADER|SHIFT",
			action = act.CloseCurrentTab({ confirm = true }),
		},
		{
			key = "|",
			mods = "LEADER|SHIFT",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		--[[ {
			key = "|",
			mods = "LEADER|SHIFT",
			action = act.SplitPane({
				direction = "Right",
				size = { Percent = 50 },
			}),
		}, ]]
		{
			key = "-",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		--[[ {
			key = "-",
			mods = "LEADER",
			action = act.SplitPane({
				direction = "Down",
				size = { Percent = 50 },
			}),
		}, ]]
		{
			key = "q",
			mods = "LEADER",
			action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }),
		},
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

		{
			key = "v",
			mods = "LEADER",
			action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "h",
			mods = "LEADER",
			action = act.SplitVertical({ domain = "CurrentPaneDomain" }),
		},
		{
			key = "b",
			mods = "LEADER|CTRL",
			action = act.SendKey({ key = "b", mods = "CTRL" }),
		},
	},
}
