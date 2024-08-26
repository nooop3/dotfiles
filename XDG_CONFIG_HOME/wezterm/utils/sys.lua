local wezterm = require("wezterm")

local M = {}

-- https://github.com/wez/wezterm/discussions/4728
M.is_darwin = wezterm.target_triple:find("darwin") ~= nil
M.is_linux = wezterm.target_triple:find("linux") ~= nil

return M
