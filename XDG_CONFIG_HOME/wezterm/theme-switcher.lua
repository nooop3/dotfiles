local wezterm = require("wezterm")
local action = wezterm.action

local M = {}

M.theme_switcher = function(window, pane)
	-- get builting color schemes
	local schemes = wezterm.color.get_builtin_schemes()
	local choices = {}
	local config_path = wezterm.config_file

	-- populate theme names in choices list
	for key, _ in pairs(schemes) do
		table.insert(choices, { label = tostring(key) })
	end

	-- sort choices list
	table.sort(choices, function(c1, c2)
		return c1.label < c2.label
	end)

	window:perform_action(
		action.InputSelector({
			title = "🎨 Pick a Theme!",
			choices = choices,
			fuzzy = true,

			-- execute 'sed' shell command to replace the line
			-- responsible of colorscheme in my config
			action = wezterm.action_callback(function(inner_window, inner_pane, _, label)
				inner_window:perform_action(
					action.SpawnCommandInNewTab({
						args = {
							"sed",
							"-i.bak",
							'/^Colorscheme/c\\Colorscheme = "' .. label .. '"',
							config_path,
						},
					}),
					inner_pane
				)
			end),
		}),
		pane
	)
end

return M
