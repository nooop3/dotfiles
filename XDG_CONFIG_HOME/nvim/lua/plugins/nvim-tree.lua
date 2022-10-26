-- import nvim-tree plugin safely
local status, nvimtree = pcall(require, "nvim-tree")
if not status then
	return
end

local map = vim.keymap.set

nvimtree.setup({
	open_on_setup = true,
	open_on_tab = true,
	sync_root_with_cwd = true,
	respect_buf_cwd = true,
	update_focused_file = {
		enable = true,
		update_root = true,
	},
})

-- Toggle nvim-tree
map("n", "<C-n>", [[:NvimTreeToggle<CR>]], { noremap = true, silent = true })
