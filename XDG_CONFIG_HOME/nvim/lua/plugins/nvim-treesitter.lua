-- import nvim-treesitter plugin safely
local status, _ = pcall(require, "nvim-treesitter")
if not status then
	return
end

local parsers = require("nvim-treesitter.parsers")
local configs = require("nvim-treesitter.configs")

local parser_configs = parsers.get_parser_configs()

-- local github_mirror = "https://hub.fastgit.xyz/"
local github_mirror = "https://github.com/"

parser_configs.gotmpl = {
	install_info = {
		url = "https://github.com/ngalaiko/tree-sitter-go-template",
		files = { "src/parser.c" },
	},
	filetype = "gotmpl",
	used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
}

for _, config in pairs(parser_configs) do
	config.install_info.url = config.install_info.url:gsub("https://github.com/", github_mirror)
end

configs.setup({
	ensure_installed = {
		"yaml",
		"hcl",
		"json",
		"sql",
		"markdown",
		"markdown_inline",
		"python",
		"bash",
		"go",
		"gomod",
		"java",
		"tsx",
		"kotlin",

		"vim",
		"lua",
		"rust",

		"php",
		"toml",
		"html",
	},

	-- Install parsers synchronously (only applied to `ensure_installed`)
	sync_install = false,

	-- List of parsers to ignore installing (for "all")
	ignore_install = {},

	highlight = {
		enable = true,
		disable = { "sql" },
		additional_vim_regex_highlighting = false,
	},
	incremental_selection = {
		enable = true,
		keymaps = {
			init_selection = "gnn",
			node_incremental = "grn",
			scope_incremental = "grc",
			node_decremental = "grm",
		},
	},
	indent = {
		enable = true,
		disable = {},
	},
	additional_vim_regex_highlighting = false,
})
parsers.filetype_to_parsername.javascript = "tsx"
parsers.filetype_to_parsername["typescript.tsx"] = "tsx"
