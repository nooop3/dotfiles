--[[ init.lua ]]

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ";"
vim.g.localleader = "\\"

-- nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- IMPORTS
require("variables")
require("options")
require("keymaps")
require("autocmd")
require("packer-config")
require("plugins")
require("neovide")
