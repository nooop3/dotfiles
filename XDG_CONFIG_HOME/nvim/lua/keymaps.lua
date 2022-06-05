--[[ keymaps.lua ]]

local map = vim.keymap.set

map("n", "<Leader>w", ":write!<CR>", { desc = "Fast saving." })
map("n", "<Leader><CR>", [[ (&hls && v:hlsearch ? ':nohls' : ':set hls')."\n" <BAR> redraw<CR>]], {
  expr = true, silent = true, desc = "Disable highlight when <leader><CR> is pressed"
})
map("n", "<space>", "za", { desc = "Enable folding with the spacebar" })

map("n", "]b", ":tabnext<CR>", { silent = true, desc = "Next tab" })
map("n", "[b", ":tabprevious<CR>", { silent = true, desc = "Previous tab" })

-- for i = 1, 10, 1 do
--   map("n", "<leader>" .. i, ":" .. i .. "tabnext<CR>", { silent = true })
-- end
map("n", "<leader>1", ":1tabnext<CR>", { silent = true })
map("n", "<leader>2", ":2tabnext<CR>", { silent = true })
map("n", "<leader>3", ":3tabnext<CR>", { silent = true })
map("n", "<leader>4", ":4tabnext<CR>", { silent = true })
map("n", "<leader>5", ":5tabnext<CR>", { silent = true })
map("n", "<leader>6", ":6tabnext<CR>", { silent = true })
map("n", "<leader>7", ":7tabnext<CR>", { silent = true })
map("n", "<leader>8", ":8tabnext<CR>", { silent = true })
map("n", "<leader>9", ":9tabnext<CR>", { silent = true })

-- Support navigating in vims command mode
map("c", "<C-A>", "<Home>", { desc = "Support navigating in vims command mode" })
map("c", "<C-E>", "<End>", { desc = "Support navigating in vims command mode" })
map("c", "<C-B>", "<Left>", { desc = "Support navigating in vims command mode" })
map("c", "<C-F>", "<Right>", { desc = "Support navigating in vims command mode" })

-- map("c", "w!!", "w !sudo tee > /dev/null %", { desc = "Allow saving of files as sudo when I forgot to start vim using sudo." })
-- map("n", "l", [[:IndentLinesToggle]], {})
-- map("n", "t", [[:TagbarToggle]], {})
