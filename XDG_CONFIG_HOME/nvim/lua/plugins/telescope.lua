-- import telescope plugin safely
local status, telescope = pcall(require, "telescope")
if not status then
	return
end

local fn = vim.fn
local map = vim.keymap.set

local actions = require("telescope.actions")
local builtin = require("telescope.builtin")
local extensions = telescope.extensions

telescope.setup({
	defaults = {
		-- Default configuration for telescope goes here:
		vimgrep_arguments = {
			"rg",
			"--color=never",
			"--no-heading",
			"--with-filename",
			"--line-number",
			"--column",
			"--smart-case",
			-- "--trim" -- add this value
		},
		mappings = {
			n = {
				["<C-c>"] = actions.close,
			},
			i = {
				-- map actions.which_key to <C-h> (default: <C-/>)
				-- actions.which_key shows the mappings for your picker,
				-- e.g. git_{create, delete, ...}_branch for the git_branches picker
				-- ["<C-h>"] = "which_key"
				-- ["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		find_files = {
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix", "--hidden", "--exclude=.git" },
		},
		-- Now the picker_config_key will be applied every time you call this
		-- builtin picker
	},
	extensions = {
		-- Your extension configuration goes here:
		-- please take a look at the readme of the extension you want to configure
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- override the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "smart_case", -- or "ignore_case" or "respect_case", the default case_mode is "smart_case"
		},
		--[[ project = {
			hidden_files = true,
			order_by = "recent",
			-- sync_with_nvim_tree = true,
		}, ]]
		["telescope-tabs"] = {
			-- entry_formatter = function(tab_id, buffer_ids, file_names, file_paths)
			--[[ entry_formatter = function(tab_id, _, _, _)
				-- local cwd = fn.getcwd(-1, tab_id)
				local cwd = vim.t[tab_id].root_dir or fn.getcwd(-1, tab_id)
				-- local root_dir = fn.substitute(cwd, '^.*/', '', '')
				local root_dir = fn.fnamemodify(cwd, ":t")
				return string.format("%d: %s, %s", tab_id, root_dir, cwd:gsub(vim.env.HOME, "~"))
			end, ]]
			-- entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths)
			entry_ordinal = function(tab_id, _, file_names, _)
				local entry = table.concat(file_names, " ")
				return string.format("%d: %s", tab_id, entry)
			end,
			show_preview = true,
			close_tab_shortcut_i = "<C-d>", -- if you're in insert mode
			close_tab_shortcut_n = "D", -- if you're in normal mode
		},
	},
})

-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
telescope.load_extension("fzf")
-- telescope.load_extension("project")
telescope.load_extension("projects")
telescope.load_extension("telescope-tabs")

local opts = { noremap = true, silent = true }
map("n", "<leader>-pp", builtin.planets, opts)

map("n", "<C-p>", builtin.find_files, opts)
map("n", "<leader>ff", builtin.find_files, opts)
map("n", "<leader>fs", builtin.grep_string, opts)
map("n", "<leader>fg", builtin.live_grep, opts)
--[[ map("n", "<leader>fp", function()
	extensions.project.project({ display_type = "full" })
end, opts) ]]
map("n", "<leader>fp", function()
  extensions.projects.projects{}
end, opts)
map("n", "<leader>fa", extensions["telescope-tabs"].list_tabs, opts)

-- Vim Pickers
map("n", "<leader>fb", builtin.buffers, opts)
map("n", "<leader>fl", builtin.current_buffer_fuzzy_find, opts)
map("n", "<leader>fw", builtin.oldfiles, opts)
map("n", "<leader>fh", builtin.help_tags, opts)
map("n", "<leader>ft", builtin.filetypes, opts)

map("n", "<leader>fo", builtin.current_buffer_tags, opts)
map("n", "<leader>fO", builtin.tags, opts)

-- Git Pickers
map("n", "<leader>gc", builtin.git_commits, opts)
map("n", "<leader>gfc", builtin.git_bcommits, opts)
map("n", "<leader>gb", builtin.git_branches, opts)
map("n", "<leader>gs", builtin.git_status, opts)
