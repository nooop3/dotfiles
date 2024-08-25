local wezterm = require("wezterm")

local act = wezterm.action

local session_manager = require("wezterm-session-manager/session-manager")

-- --------------------------------------------------------------------
-- FUNCTIONS AND EVENT BINDINGS
-- --------------------------------------------------------------------

-- Session Manager event bindings
-- See https://github.com/danielcopper/wezterm-session-manager
-- curl --create-dirs -O --output-dir ~/.config/wezterm/wezterm-session-manager/ https://raw.githubusercontent.com/danielcopper/wezterm-session-manager/main/session-manager.lua
wezterm.on("save_session", function(window)
	session_manager.save_state(window)
end)
wezterm.on("load_session", function(window)
	session_manager.load_state(window)
end)
wezterm.on("restore_session", function(window)
	session_manager.restore_state(window)
end)

local keys = {
	-- Session manager bindings
	{ key = "s", mods = "LEADER|SHIFT", action = act({ EmitEvent = "save_session" }) },
	{ key = "L", mods = "LEADER|SHIFT", action = act({ EmitEvent = "load_session" }) },
	{ key = "R", mods = "LEADER|SHIFT", action = act({ EmitEvent = "restore_session" }) },
}

return {
	keys = keys,
}
