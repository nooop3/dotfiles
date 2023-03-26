--[[ plugins.lua ]]

return {
	-- [[ Theme ]]
  {
    -- "Mofiqul/dracula.nvim",
    -- colorscheme dracula
	  "sainnhe/gruvbox-material",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    config = function()
      -- load the colorscheme here
      vim.cmd([[colorscheme gruvbox-material]])
    end,
  },

  -- if some code requires a module from an unloaded plugin, it will be automatically loaded.
  -- So for api plugins like devicons, we can always set lazy=true
  { "nvim-tree/nvim-web-devicons", lazy = true },

	-- start screen
	-- "mhinz/vim-startify",
	-- cursor jump
	-- "DanilaMihailov/beacon.nvim",

	-- essential plugins
	-- add, delete, change surroundings (it's awesome)
	"tpope/vim-surround",
	-- "tpope/vim-fugitive", -- git integration
	-- "junegunn/gv.vim", -- commit history

	"b0o/schemastore.nvim",
	-- [[ Dev ]]
	-- sudo pacman -S ctags
	"majutsushi/tagbar",

	-- Rust
	"simrat39/rust-tools.nvim",

	-- "voldikss/vim-floaterm",
	-- "lewis6991/impatient.nvim",
	-- "tpope/vim-commentary",
	-- "mbbill/undotree",
	-- "vimwiki/vimwiki",

	-- "github/copilot.vim",
	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	-- if packer_bootstrap then
	-- 	require("packer",.sync(,
	-- end
}
-- {
--     compile_path = fn.stdpath("data", .. "/site/plugin/packer_compiled.lua",
--     git = {
--       default_url_format = "https://github.com/%s", -- Lua format string used for "aaa/bbb" style plugins
--       -- default_url_format = "https://hub.fastgit.xyz/%s"
--     },
--     -- display = {
--     -- open_fn = require("packer.util",.float,
--     -- }
-- }
