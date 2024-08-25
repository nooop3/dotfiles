local wezterm = require("wezterm")

local mux = wezterm.mux

-- event
wezterm.on("gui-startup", function()
	---@diagnostic disable-next-line: unused-local
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

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
