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
			i = {
				-- map actions.which_key to <C-h> (default: <C-/>)
				-- actions.which_key shows the mappings for your picker,
				-- e.g. git_{create, delete, ...}_branch for the git_branches picker
				-- ["<C-h>"] = "which_key"
				["<esc>"] = actions.close,
				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,
			},
		},
	},
	pickers = {
		-- Default configuration for builtin pickers goes here:
		find_files = {
			-- picker_config_key = value,
			find_command = { "fd", "--type", "f", "--strip-cwd-prefix" },
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
		["telescope-tabs"] = {
			-- entry_formatter = function(tab_id, buffer_ids, file_names, file_paths)
			entry_formatter = function(tab_id, _, _, _)
				local cwd = fn.getcwd(-1, tab_id)
				-- local root_dir = fn.substitute(cwd, '^.*/', '', '')
				local root_dir = fn.fnamemodify(cwd, ":t")
				print(tab_id, root_dir, cwd)
				return string.format("%d: %s, %s", tab_id, root_dir, cwd)
			end,
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
telescope.load_extension("projects")
telescope.load_extension("telescope-tabs")

map("n", "<leader>-pp", builtin.planets, { silent = true })

map("n", "<C-p>", builtin.find_files, { silent = true })
map("n", "<leader>ff", builtin.find_files, { silent = true })
map("n", "<leader>fs", builtin.grep_string, { silent = true })
map("n", "<leader>fg", builtin.live_grep, { silent = true })
map("n", "<leader>fp", extensions.projects.projects, { silent = true })
map("n", "<leader>fa", extensions["telescope-tabs"].list_tabs, { silent = true })

-- Vim Pickers
map("n", "<leader>fb", builtin.buffers, { silent = true })
map("n", "<leader>fl", builtin.current_buffer_fuzzy_find, { silent = true })
map("n", "<leader>fw", builtin.oldfiles, { silent = true })
map("n", "<leader>fh", builtin.help_tags, { silent = true })
map("n", "<leader>ft", builtin.filetypes, { silent = true })

map("n", "<leader>fo", builtin.current_buffer_tags, { silent = true })
map("n", "<leader>fO", builtin.tags, { silent = true })

-- Git Pickers
map("n", "<leader>gc", builtin.git_commits, { silent = true })
map("n", "<leader>gfc", builtin.git_bcommits, { silent = true })
map("n", "<leader>gb", builtin.git_branches, { silent = true })
map("n", "<leader>gs", builtin.git_status, { silent = true })
