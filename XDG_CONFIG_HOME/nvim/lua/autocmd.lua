--[[ autpcmd.lua ]]

local o = vim.o
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
-- local opt = vim.opt
local opt_local = vim.opt_local
local map = vim.keymap.set
local has = vim.fn.has
local system = vim.fn.system
local trim = vim.fn.trim
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- https://github.com/vim/vim/blob/master/runtime/defaults.vim#L101
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
local vim_startup = augroup("vimStartup", { clear = true })
autocmd({ "BufReadPost" }, {
	group = vim_startup,
	pattern = { "*" },
	callback = function()
		local quote_mark_line = fn.line("'" .. '"')
		local last_line = fn.line("$")
		if quote_mark_line >= 1 and quote_mark_line <= last_line and o.ft ~= "commit" then
			cmd('normal! g`"')
		end
	end,
})

-- Markdown add the checkbox
local markdown_checkbox = augroup("MarkdownCheckbox", { clear = true })
autocmd({ "FileType" }, {
	group = markdown_checkbox,
	pattern = { "markdown" },
	callback = function()
		map(
			{ "n", "v" },
			"<Leader>x<space>",
			":s/^\\s*\\(- \\\\|\\* \\)\\?\\zs\\(\\[[^\\]]*\\] \\)\\?\\ze./[ ] /<CR>0t]<CR>",
			{
				buffer = true,
				silent = true,
				desc = "Add checkbox",
			}
		)
		map({ "n", "v" }, "<Leader>xx", ":s/^\\s*\\(- \\\\|\\* \\)\\?\\zs\\(\\[[^\\]]*\\] \\)\\?\\ze./[x] /<CR>0t]<CR>", {
			buffer = true,
			silent = true,
			desc = "Add checkbox",
		})
	end,
})

-- Auto change the tabstop
local file_type_tab_stop = augroup("FileTypeTabStop", { clear = true })
autocmd({ "FileType" }, {
	group = file_type_tab_stop,
	pattern = { "markdown" },
	callback = function()
		opt_local.tabstop = 4
		opt_local.softtabstop = 4
		opt_local.shiftwidth = 4
	end,
})
autocmd({ "FileType" }, {
	group = file_type_tab_stop,
	pattern = {
		"javascript",
		"json",
		"css",
		"lua",
	},
	callback = function()
		opt_local.tabstop = 2
		opt_local.softtabstop = 2
		opt_local.shiftwidth = 2
	end,
})
-- autocmd({"BufNewFile", "BufRead"}, {
--   group = file_type_tab_stop,
--   pattern = { "*.js", "*.json", "*.ts", "*.html", "*.css", "*.yml", "*.proto", "*.sh" },
--   callback = function()
--     opt_local.tabstop = 2
--     opt_local.softtabstop = 2
--     opt_local.shiftwidth = 2
--   end
-- })

-- Custom file type changes
local custom_file_type_changes = augroup("CustomFileTypeChanges", { clear = true })
autocmd({ "BufNewFile", "BufRead" }, {
	group = custom_file_type_changes,
	pattern = { "crontab*" },
	callback = function()
		opt_local.filetype = "crontab"
	end,
})
autocmd({ "BufNewFile", "BufRead" }, {
	group = custom_file_type_changes,
	pattern = { "*.nomad" },
	callback = function()
		opt_local.filetype = "hcl"
	end,
})
autocmd({ "BufNewFile", "BufRead" }, {
	group = custom_file_type_changes,
	pattern = { "*" },
	callback = function()
		if vim.fn.expand("%:e"):match("ya?ml") and vim.fn.search("{{.\\+}}", "nw") ~= 0 then
			opt_local.filetype = "gotmpl"
		end
	end,
})

-- Delete trailing white space on save, useful for Python and CoffeeScript ;)
local delete_trailing_white_space = augroup("DeleteTrailingWhiteSpace", { clear = true })
autocmd({ "BufWrite" }, {
	group = delete_trailing_white_space,
	pattern = { "*.py", "*.pyw", "*.c", "*h", "*.coffee", "*.md" },
	callback = function()
		if not o.binary and o.filetype ~= "diff" then
			local current_view = fn.winsaveview()
			cmd([[keeppatterns %s/\s\+$//e]])
			fn.winrestview(current_view)
		end
	end,
})

-- autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()
-- local terraform_format = augroup("TerraformFormat", { clear = true })
-- autocmd({"BufWritePre"}, {
--   group = terraform_format,
--   pattern = { "*.tf" },
--   callback = function()
--     return vim.lsp.buf.formatting_sync()
--   end
-- })

g.input_toggle = 0
local fcitx2en = function()
	local input_status = trim(system("fcitx5-remote"))
	if input_status == "2" then
		g.input_toggle = 1
		system("fcitx5-remote -c")
	end
end
local fcitx2zh = function()
	local input_status = trim(system("fcitx5-remote"))
	if input_status ~= "2" and g.input_toggle == 1 then
		system("fcitx5-remote -o")
		g.input_toggle = 0
	end
end

if has("Mac") == 0 then
	-- opt.timeoutlen = 150
	local auto_fcitx = augroup("AutoFcitx", { clear = true })
	autocmd({ "InsertLeave" }, {
		group = auto_fcitx,
		pattern = { "*" },
		callback = fcitx2en,
	})
	autocmd({ "InsertEnter" }, {
		group = auto_fcitx,
		pattern = { "*" },
		callback = fcitx2zh,
	})
end
