--[[ plugins.lua ]]

return {
  { "folke/lazy.nvim", version = "*" },
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "nvim-lua/plenary.nvim", lazy = true },

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
