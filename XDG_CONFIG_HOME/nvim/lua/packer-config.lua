--[[ plugins.lua ]]

local fn = vim.fn

local ensure_packer = function()
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    -- fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    fn.system({"git", "clone", "--depth", "1", "https://hub.fastgit.xyz/wbthomason/packer.nvim", install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

-- import packer safely
local status, packer = pcall(require, "packer")
if not status then
	return
end

-- Only required if you have packer configured as `opt`
-- vim.cmd [[packadd packer.nvim]]

return packer.startup({function(use)
  -- Packer can manage itself
  use "wbthomason/packer.nvim"

  -- [[ Theme ]]
  use "sainnhe/gruvbox-material"
  use "Mofiqul/dracula.nvim"
  -- start screen
  -- use "mhinz/vim-startify"
  -- cursor jump
  -- use { "DanilaMihailov/beacon.nvim" }
  -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
  use {
    "nvim-lualine/lualine.nvim",
    requires = { "kyazdani42/nvim-web-devicons", opt = false }
  }

  -- essential plugins
	use("tpope/vim-surround") -- add, delete, change surroundings (it's awesome)

  -- A file explorer tree for neovim written in lua
  use {
    "kyazdani42/nvim-tree.lua",
    requires = {
      "kyazdani42/nvim-web-devicons", -- optional, for file icon
    },
    tag = "nightly" -- optional, updated every week. (see issue #1193)
  }
  use "ahmedkhalf/project.nvim"

  -- Collection of configurations for the built-in LSP client
  use "neovim/nvim-lspconfig"

  -- Improve LSP UI
  -- use "glepnir/lspsaga.nvim"
  use "tami5/lspsaga.nvim"

  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate"
  }
  -- LSP source for nvim-cmp
  use "hrsh7th/cmp-nvim-lsp"
  use "hrsh7th/cmp-nvim-lua"
  use "hrsh7th/cmp-nvim-lsp-signature-help"
  use "hrsh7th/cmp-buffer"
  use "hrsh7th/cmp-path"
  use "hrsh7th/cmp-cmdline"
  -- Autocompletion plugin
  use "hrsh7th/nvim-cmp"
  -- Snippets plugin
  use "L3MON4D3/LuaSnip"
  -- Snippets source for nvim-cmp
  use "saadparwaiz1/cmp_luasnip"

  use "mfussenegger/nvim-lint"

  -- [[ Dev ]]
  use {
    -- fuzzy finder
    "nvim-telescope/telescope.nvim",
    requires = { {"nvim-lua/plenary.nvim"} }
  }
  use {"nvim-telescope/telescope-fzf-native.nvim", run = "make" }
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'}
  }
  use "majutsushi/tagbar"                          -- see indentation
  -- code structure
  use "Yggdroot/indentLine"
  use "tpope/vim-fugitive"                         -- git integration
  use "junegunn/gv.vim"                            -- commit history
  use "windwp/nvim-autopairs"

  use 'terrortylor/nvim-comment'

  -- Rust
  use "simrat39/rust-tools.nvim"

  -- use "voldikss/vim-floaterm"
  -- use "lewis6991/impatient.nvim"
  -- use "tpope/vim-commentary"
  -- use "mbbill/undotree"
  -- use "vimwiki/vimwiki"
  -- use "pope/vim-surround"

  -- use "github/copilot.vim"
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if packer_bootstrap then
    require("packer").sync()
  end
end,
config = {
  compile_path = fn.stdpath("data") .. "/site/plugin/packer_compiled.lua",
  git = {
    default_url_format = "https://github.com/%s" -- Lua format string used for "aaa/bbb" style plugins
    -- default_url_format = "https://hub.fastgit.xyz/%s"
  }
  -- display = {
    -- open_fn = require("packer.util").float,
  -- }
}})
