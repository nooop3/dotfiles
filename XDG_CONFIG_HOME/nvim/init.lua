--[[ init.lua ]]

local fn = vim.fn

-- lazy settings
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(install_path) then
	fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		-- "https://hub.fastgit.xyz/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		install_path,
	})
	return true
end
vim.opt.rtp:prepend(install_path)

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ";"
vim.g.localleader = "\\"

require("lazy").setup("plugins", {
	change_detection = {
		enabled = false,
	},
})

-- nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- netrw
-- vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_browse_split = 4
-- vim.g.netrw_altv = 1
-- vim.g.netrw_winsize = 25

-- IMPORTS
require("variables")
require("options")
require("keymaps")
require("autocmd")
require("neovide")
