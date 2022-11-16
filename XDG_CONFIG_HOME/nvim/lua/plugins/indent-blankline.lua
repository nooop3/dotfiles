-- import indent_blankline plugin safely
local status, blankline = pcall(require, "indent_blankline")
if not status then
	return
end

blankline.setup({
	show_current_context = true,
	use_treesitter = true,
	-- show_current_context_start = true,
})
