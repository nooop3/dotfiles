--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ";"
vim.g.localleader = "\\"

-- IMPORTS
require("variables")
require("options")
require("keymaps")
require("autocmd")
require("packer-config")
require("plugins")
require("neovide")
