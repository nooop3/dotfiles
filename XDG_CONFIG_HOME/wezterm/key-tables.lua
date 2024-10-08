local wezterm = require("wezterm")

local act = wezterm.action

local search_mode = nil
if wezterm.gui then
	search_mode = wezterm.gui.default_key_tables().search_mode
	table.insert(search_mode, {
		key = "Escape",
		mods = "NONE",
		action = act.Multiple({
			act.CopyMode("ClearPattern"),
			act.CopyMode("Close"),
		}),
	})
	table.insert(search_mode, {
		key = "Escape",
		mods = "CTRL",
		action = act.CopyMode("Close"),
	})
end

local copy_mode = nil
if wezterm.gui then
	copy_mode = wezterm.gui.default_key_tables().copy_mode
	table.insert(copy_mode, {
		key = "y",
		mods = "NONE",
		action = act.Multiple({
			{ CopyTo = "ClipboardAndPrimarySelection" },
			{ CopyMode = { SetSelectionMode = "Cell" } },
		}),
	})
	table.insert(copy_mode, {
		key = "Y",
		mods = "NONE",
		action = act.Multiple({
			{ CopyTo = "ClipboardAndPrimarySelection" },
			{ Multiple = { "ScrollToBottom", { CopyMode = "Close" } } },
		}),
	})
end

local function resize_pane(key, direction)
	return {
		key = key,
		action = act.AdjustPaneSize({ direction, 1 }),
	}
end

local function activate_pane(key, direction)
	return {
		key = key,
		action = act.ActivatePaneDirection(direction),
	}
end

return {
	search_mode = search_mode,
	copy_mode = copy_mode,

	-- Defines the keys that are active in our resize-pane mode.
	-- Since we're likely to want to make multiple adjustments,
	-- we made the activation one_shot=false. We therefore need
	-- to define a key assignment for getting out of this mode.
	-- 'resize_pane' here corresponds to the name="resize_pane" in
	-- the key assignments above.
	resize_pane = {
		resize_pane("LeftArrow", "Left"),
		resize_pane("h", "Left"),

		resize_pane("RightArrow", "Right"),
		resize_pane("l", "Right"),

		resize_pane("UpArrow", "Up"),
		resize_pane("k", "Up"),

		resize_pane("DownArrow", "Down"),
		resize_pane("j", "Down"),

		-- Cancel the mode by pressing escape
		{ key = "Escape", action = "PopKeyTable" },
		{ key = "q", action = "PopKeyTable" },
	},

	-- Defines the keys that are active in our activate-pane mode.
	-- 'activate_pane' here corresponds to the name="activate_pane" in
	-- the key assignments above.
	activate_pane = {
		activate_pane("LeftArrow", "Left"),
		activate_pane("h", "Left"),
		activate_pane("RightArrow", "Right"),
		activate_pane("l", "Right"),
		activate_pane("UpArrow", "Up"),
		activate_pane("k", "Up"),
		activate_pane("DownArrow", "Down"),
		activate_pane("j", "Down"),
	},
}
