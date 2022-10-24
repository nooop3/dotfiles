--[[ plugins/nvim-tree.lua ]]
-- import nvim-tree plugin safely
local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
	return
end

local map = vim.keymap.set

nvimtree.setup({
  open_on_setup = true,
  open_on_tab = true,
  update_cwd = true,
  update_focused_file = {
    enable = true,
    update_cwd = true,
    ignore_list = {},
  },
})

-- Toggle nvim-tree
map("n", "<C-n>", [[:NvimTreeToggle<CR>]], { silent = true })
