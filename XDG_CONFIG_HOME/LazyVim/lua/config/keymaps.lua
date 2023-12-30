-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set

map("n", "<leader>1", ":1tabnext<CR>", { silent = true })
map("n", "<leader>2", ":2tabnext<CR>", { silent = true })
map("n", "<leader>3", ":3tabnext<CR>", { silent = true })
map("n", "<leader>4", ":4tabnext<CR>", { silent = true })
map("n", "<leader>5", ":5tabnext<CR>", { silent = true })
map("n", "<leader>6", ":6tabnext<CR>", { silent = true })
map("n", "<leader>7", ":7tabnext<CR>", { silent = true })
map("n", "<leader>8", ":8tabnext<CR>", { silent = true })
map("n", "<leader>9", ":9tabnext<CR>", { silent = true })

-- quick select last changed block
-- nnoremap <expr> gV '`[' . getregtype()[0] . '`]'
map("n", "gV", [["`[" .. getregtype()[0] .. "`]"]], { expr = true, desc = "Quick select last changed block" })
