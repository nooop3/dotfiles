-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

-- quick select last changed block
-- nnoremap <expr> gV '`[' . getregtype()[0] . '`]'
map("n", "gV", [["`[" .. getregtype()[0] .. "`]"]], { expr = true, desc = "Quick select last changed block" })
