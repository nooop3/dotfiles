--[[ init.lua ]]

local fn = vim.fn
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  -- packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path})
  packer_bootstrap = fn.system({"git", "clone", "--depth", "1", "https://hub.fastgit.xyz/wbthomason/packer.nvim", install_path})
end

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
