-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Colortheme gruvbox material
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_enable_italic = 1
-- vim.g.gruvbox_material_dim_inactive_windows = 1

vim.opt.swapfile = false
-- vim.opt.wrap = true
vim.opt.clipboard = ""
vim.opt.cursorcolumn = true
vim.opt.termsync = false

--[[ neovide ]]
if vim.g.neovide then
  vim.opt.guifont = "SauceCodePro NF"
  -- vim.g.neovide_fullscreen = true
  vim.g.neovide_remember_window_size = true
  -- g.neovide_cursor_vfx_mode = "railgun"
end
