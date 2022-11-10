-- import project.nvim plugin safely
local status, project = pcall(require, "project_nvim")
if not status then
	return
end

project.setup({
	detection_methods = { "pattern", "lsp" },
	-- patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
	ignore_lsp = {},
	exclude_dirs = { "~/.cargo/*" },
	show_hidden = true,
	silent_chdir = false,
	scope_chdir = "tab",
})
