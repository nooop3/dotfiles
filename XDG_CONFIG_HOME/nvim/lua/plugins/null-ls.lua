-- import null-ls plugin safely
local status, null_ls = pcall(require, "null-ls")
if not status then
	return
end

-- for conciseness
local diagnostics = null_ls.builtins.diagnostics
local formatting = null_ls.builtins.formatting
local code_actions = null_ls.builtins.code_actions

-- to setup format on save
local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

null_ls.setup({
	sources = {
		-- setup code actions
		-- filetypes: "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"
		code_actions.eslint_d,
		-- filetypes: "sh"
		code_actions.shellcheck,
		code_actions.gitsigns,

		-- filetypes: "proto"
		-- install: yay -S protolint
		diagnostics.protolint,
		-- filetypes: "sh"
		diagnostics.shellcheck,
		-- filetypes: "sql"
		-- install: sudo pacman -S sqlfluff
		diagnostics.sqlfluff.with({
			args = { "lint", "--disable-progress-bar", "-f", "github-annotation", "-n", "$FILENAME" },
			extra_args = { "--dialect", "postgres" }, -- change to your dialect
		}),
		-- filetypes: "markdown", "tex", "asciidoc"
		diagnostics.vale,
		-- filetypes: "yaml"
		diagnostics.yamllint,

		-- setup code formatters
		-- filetypes: "javascript", "javascriptreact"
		-- formatting.prettier,
		-- filetypes: "proto"
		-- install:
		-- Arch:
		-- yay -S protolint
		-- brew tap yoheimuta/protolint
		-- brew install protolint
		formatting.protolint,
		-- filetypes: "lua", "luau"
		-- install: sudo pacman -S stylua
		formatting.stylua,
		-- filetypes: "hcl"
		-- formatting.packer,
		-- filetypes: "sql", "pgsql"
		-- install: sudo pacman -S pgformatter
		formatting.pg_format.with({
			extra_args = {
				"--keep-newline=1",
				"--no-extra-line=1",
				"--redshift",
				-- "--extra-function=/home/edward/.pg_format/functions.lst",
			},
		}),
		-- filetypes: "terraform", "tf"
		formatting.terraform_fmt,
	},
	-- configure format on save
	on_attach = function(current_client, bufnr)
		if current_client.supports_method("textDocument/formatting") then
			vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
			vim.api.nvim_create_autocmd("BufWritePre", {
				group = augroup,
				buffer = bufnr,
				callback = function()
					vim.lsp.buf.format({
						filter = function(client)
							--  only use null-ls for formatting instead of lsp server
							return client.name == "null-ls"
						end,
						bufnr = bufnr,
					})
				end,
			})
		end
	end,
})
