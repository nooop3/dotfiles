local wezterm = require("wezterm")

local mux = wezterm.mux

-- event
wezterm.on("gui-startup", function()
	---@diagnostic disable-next-line: unused-local
	local tab, pane, window = mux.spawn_window({})
	window:gui_window():maximize()
end)

-- Returns a bool based on whether the host operating system's
-- appearance is light or dark.
local function is_dark()
	-- wezterm.gui is not always available, depending on what
	-- environment wezterm is operating in. Just return true
	-- if it's not defined.
	if wezterm.gui then
		-- Some systems report appearance like "Dark High Contrast"
		-- so let's just look for the string "Dark" and if we find
		-- it assume appearance is dark.
		return wezterm.gui.get_appearance():find("Dark")
	end
	return true
end

local function segments_for_right_status(window)
	-- Show which key table is active in the status area
	local key_table = window:active_key_table()
	if key_table then
		key_table = key_table:gsub("^%l", string.upper):gsub("_", " ")
		-- key_table = string.gsub(" " .. key_table, "%W%l", string.upper):sub(2):gsub("_", " ")
		key_table = table.concat({ wezterm.nerdfonts.md_keyboard, key_table }, " ")
	else
		key_table = ""
	end

	local date = wezterm.strftime("%a %b %-d %H:%M ")

	return {
		key_table,
		window:active_workspace(),
		date,
	}
end

wezterm.on("update-status", function(window)
	local SOLID_LEFT_ARROW = wezterm.nerdfonts.pl_right_hard_divider
	local segments = segments_for_right_status(window)

	local color_scheme = window:effective_config().resolved_palette
	-- Note the use of wezterm.color.parse here, this returns
	-- a Color object, which comes with functionality for lightening
	-- or darkening the colour (amongst other things).
	local bg = wezterm.color.parse(color_scheme.background)
	local fg = color_scheme.foreground

	-- Each powerline segment is going to be coloured progressively
	-- darker/lighter depending on whether we're on a dark/light colour
	-- scheme. Let's establish the "from" and "to" bounds of our gradient.
	local gradient_to, gradient_from = bg, bg
	if is_dark() then
		gradient_from = gradient_to:lighten(0.2)
	else
		gradient_from = gradient_to:darken(0.2)
	end

	local gradient = wezterm.color.gradient(
		{
			orientation = "Horizontal",
			colors = { gradient_from, gradient_to },
		},
		#segments -- only gives us as many colours as we have segments.
	)

	local elements = {}

	for i, seg in ipairs(segments) do
		if seg == "" then
			goto continue
		end

		table.insert(elements, { Foreground = { Color = gradient[i] } })
		table.insert(elements, { Text = SOLID_LEFT_ARROW })
		table.insert(elements, { Foreground = { Color = fg } })
		table.insert(elements, { Background = { Color = gradient[i] } })
		table.insert(elements, { Text = " " .. seg .. " " })

		::continue::
	end

	window:set_right_status(wezterm.format(elements))
end)
