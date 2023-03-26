return {
	{
		"ahmedkhalf/project.nvim",
		version = false,
		config = function()
			local project = require("project_nvim")
			project.setup({
				detection_methods = { "pattern", "lsp" },
				-- patterns = { ".git", "_darcs", ".hg", ".bzr", ".svn", "Makefile", "package.json" },
				ignore_lsp = {},
				exclude_dirs = { "~/.cargo/*" },
				show_hidden = true,
				silent_chdir = false,
				scope_chdir = "tab",
			})
		end,
	},
}
