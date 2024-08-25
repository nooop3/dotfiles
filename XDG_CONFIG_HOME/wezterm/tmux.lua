local wezterm = require("wezterm")

local utils = require("utils")

local act = wezterm.action
local mux = wezterm.mux

local M = {}

M.leader = {
	key = "b",
	mods = "CTRL",
	timeout_milliseconds = 1000,
}

local tmux_activate_tab_keys = {}
for i = 1, 9 do
	table.insert(tmux_activate_tab_keys, {
		key = tostring(i),
		mods = "LEADER",
		action = act.ActivateTab(i - 1),
	})
end

M.keys = {
	{ key = "b", mods = "LEADER|CTRL", action = act.SendKey({ key = "b", mods = "CTRL" }) },
	-- Clockwise or CounterClockwise
	{ key = "o", mods = "LEADER|CTRL", action = act.RotatePanes("Clockwise") },
	-- bind-key    -T prefix C-z     suspend-client
	-- bind-key    -T prefix Space   next-layout
	-- bind-key    -T prefix !       break-pane
	-- { key = '"', mods = "LEADER|SHIFT", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
	{ key = '"', mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Down", size = { Percent = 50 }, top_level = true }) },
	-- bind-key    -T prefix \#      list-buffers
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
	-- { key = "%", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "%", mods = "LEADER|SHIFT", action = act.SplitPane({ direction = "Right", size = { Percent = 50 }, top_level = true }) },
	{ key = "&", mods = "LEADER|SHIFT", action = act.CloseCurrentTab({ confirm = true }) },
	-- bind-key    -T prefix \'      command-prompt -T window-target -p index { select-window -t ":%%" }
	-- bind-key    -T prefix (       switch-client -p
	-- bind-key    -T prefix )       switch-client -n
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
	-- bind-key    -T prefix -       delete-buffer
	-- bind-key    -T prefix .       command-prompt -T target { move-window -t "%%" }
	-- bind-key    -T prefix /       command-prompt -k -p key { list-keys -1N "%%" }
	-- bind-key    -T prefix :       command-prompt
	{ key = ";", mods = "LEADER", action = act.ActivatePaneDirection("Prev") },
	-- bind-key    -T prefix <       display-menu -T "#[align=centre]#{window_index}:#{window_name}" -x W -y W "#{?#{>:#{session_windows},1},,-}Swap Left" l { swap-window -t :-1 } "#{?#{>:#{session_windows},1},,-}Swap Right" r { swap-window -t :+1 } "#{?pane_marked_set,,-}Swap Marked" s { swap-window } '' Kill X { kill-window } Respawn R { respawn-window -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } Rename n { command-prompt -F -I "#W" { rename-window -t "#{window_id}" "%%" } } '' "New After" w { new-window -a } "New At End" W { new-window }
	-- bind-key    -T prefix =       choose-buffer -Z
	-- bind-key    -T prefix >       display-menu -T "#[align=centre]#{pane_index} (#{pane_id})" -x P -y P "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Top,}" < { send-keys -X history-top } "#{?#{m/r:(copy|view)-mode,#{pane_mode}},Go To Bottom,}" > { send-keys -X history-bottom } '' "#{?mouse_word,Search For #[underscore]#{=/9/...:mouse_word},}" C-r { if-shell -F "#{?#{m/r:(copy|view)-mode,#{pane_mode}},0,1}" "copy-mode -t=" ; send-keys -X -t = search-backward "#{q:mouse_word}" } "#{?mouse_word,Type #[underscore]#{=/9/...:mouse_word},}" C-y { copy-mode -q ; send-keys -l "#{q:mouse_word}" } "#{?mouse_word,Copy #[underscore]#{=/9/...:mouse_word},}" c { copy-mode -q ; set-buffer "#{q:mouse_word}" } "#{?mouse_line,Copy Line,}" l { copy-mode -q ; set-buffer "#{q:mouse_line}" } '' "Horizontal Split" h { split-window -h } "Vertical Split" v { split-window -v } '' "#{?#{>:#{window_panes},1},,-}Swap Up" u { swap-pane -U } "#{?#{>:#{window_panes},1},,-}Swap Down" d { swap-pane -D } "#{?pane_marked_set,,-}Swap Marked" s { swap-pane } '' Kill X { kill-pane } Respawn R { respawn-pane -k } "#{?pane_marked,Unmark,Mark}" m { select-pane -m } "#{?#{>:#{window_panes},1},,-}#{?window_zoomed_flag,Unzoom,Zoom}" z { resize-pane -Z }
	-- bind-key    -T prefix ?       list-keys -N
	-- bind-key    -T prefix C       customize-mode -Z
	-- bind-key    -T prefix D       choose-client -Z
	-- bind-key    -T prefix E       select-layout -E
	-- bind-key    -T prefix L       switch-client -l
	-- bind-key    -T prefix M       select-pane -M
	{ key = "[", mods = "LEADER", action = act.ActivateCopyMode },
	{ key = "]", mods = "LEADER", action = act.PasteFrom("PrimarySelection") },
	{ key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
	{ key = "d", mods = "LEADER", action = act.DetachDomain("CurrentPaneDomain") },
	-- bind-key    -T prefix f       command-prompt { find-window -Z "%%" }
	-- bind-key    -T prefix i       display-message
	-- bind-key    -T prefix l       last-window
	-- bind-key    -T prefix m       select-pane -m
	{ key = "n", mods = "LEADER", action = act.ActivateTabRelative(1) },
	{ key = "o", mods = "LEADER", action = act.ActivatePaneDirection("Next") },
	{ key = "p", mods = "LEADER", action = act.ActivateTabRelative(-1) },
	{ key = "q", mods = "LEADER", action = act.PaneSelect({ mode = "Activate" }) },
	-- bind-key    -T prefix r       refresh-client
	{ key = "s", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	-- bind-key    -T prefix t       clock-mode
	{ key = "w", mods = "LEADER", action = act.ShowTabNavigator },
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },
	{ key = "{", mods = "LEADER|SHIFT", action = act.PaneSelect({ mode = "SwapWithActiveKeepFocus" }) },
	-- bind-key    -T prefix \}      swap-pane -D
	-- bind-key    -T prefix \~      show-messages
	-- bind-key -r -T prefix DC      refresh-client -c
	-- bind-key    -T prefix PPage   copy-mode -u
	{
		key = "t",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "activate_pane",
			timeout_milliseconds = 2000,
		}),
	},
	-- bind-key    -T prefix M-1     select-layout even-horizontal
	-- bind-key    -T prefix M-2     select-layout even-vertical
	-- bind-key    -T prefix M-3     select-layout main-horizontal
	-- bind-key    -T prefix M-4     select-layout main-vertical
	-- bind-key    -T prefix M-5     select-layout tiled
	-- bind-key    -T prefix M-n     next-window -a
	-- bind-key    -T prefix M-o     rotate-window -D
	-- bind-key    -T prefix M-p     previous-window -a
	{
		key = "r",
		mods = "LEADER",
		action = act.ActivateKeyTable({
			name = "resize_pane",
			one_shot = false,
		}),
	},
	-- bind-key -r -T prefix S-Up    refresh-client -U 10
	-- bind-key -r -T prefix S-Down  refresh-client -D 10
	-- bind-key -r -T prefix S-Left  refresh-client -L 10
	-- bind-key -r -T prefix S-Right refresh-client -R 10
}

utils.table.merge_table(M.keys, tmux_activate_tab_keys)

return M
