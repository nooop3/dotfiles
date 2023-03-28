local Util = require("util")

return {
	-- fuzzy finder
	{
		"nvim-telescope/telescope.nvim",
		cmd = "Telescope",
		version = false,
		keys = {

			--[[ map("n", "<leader>fp", function()
			extensions.project.project({ display_type = "full" })
			end, opts) ]]
			{
				"<leader>fp",
				function()
					require("telescope").extensions.projects.projects({})
				end,
				desc = "Projects - personal",
			},
			-- map("n", "<leader>fa", extensions["telescope-tabs"].list_tabs, opts)

			-- personalize
			{ "<c-p>", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd) - personal" },
			{ "<leader>fg", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd) - personal" },
			{ "<leader>fs", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd) - personal" },
			{ "<leader>ft", Util.telescope("filetypes"), desc = "Filetypes" },

			{ "<leader>fo", Util.telescope("current_buffer_tags"), desc = "Filetypes" },
			{ "<leader>fO", Util.telescope("tags"), desc = "tags" },

			{ "<leader>-pp", Util.telescope("planets"), desc = "Planets" },

			-- LazyVim
			{ "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
			{ "<leader>/", Util.telescope("live_grep"), desc = "Find in Files (Grep)" },
			{ "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader><space>", Util.telescope("files"), desc = "Find Files (root dir)" },
			-- find
			{ "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
			{ "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
			{ "<leader>fF", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
			{ "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
			-- git
			{ "<leader>gl", "<cmd>Telescope git_bcommits<CR>", desc = "bcommits" },
			{ "<leader>gb", "<cmd>Telescope git_branches<CR>", desc = "branches" },
			{ "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
			{ "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
			-- search
			{ "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
			{ "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
			{ "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
			{ "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
			{ "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
			{ "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
			{ "<leader>sG", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
			{ "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
			{ "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
			{ "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
			{ "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
			{ "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
			{ "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
			{ "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
			{ "<leader>sw", Util.telescope("grep_string"), desc = "Word (root dir)" },
			{ "<leader>sW", Util.telescope("grep_string", { cwd = false }), desc = "Word (cwd)" },
			{
				"<leader>uC",
				Util.telescope("colorscheme", { enable_preview = true }),
				desc = "Colorscheme with preview",
			},
			{
				"<leader>ss",
				Util.telescope("lsp_document_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol",
			},
			{
				"<leader>sS",
				Util.telescope("lsp_workspace_symbols", {
					symbols = {
						"Class",
						"Function",
						"Method",
						"Constructor",
						"Interface",
						"Module",
						"Struct",
						"Trait",
						"Field",
						"Property",
					},
				}),
				desc = "Goto Symbol (Workspace)",
			},
		},
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			-- "nvim-telescope/telescope-project.nvim",
			"LukasPietzschmann/telescope-tabs",
			"ahmedkhalf/project.nvim",
		},
		opts = function()
			local fn = vim.fn

			local actions = require("telescope.actions")
			local telescope = require("telescope")
			-- local extensions = telescope.extensions

			-- To get fzf loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			telescope.load_extension("fzf")
			-- telescope.load_extension("project")
			telescope.load_extension("projects")
			telescope.load_extension("telescope-tabs")
			return {
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
							["q"] = actions.close,
						},
						i = {
							-- map actions.which_key to <C-h> (default: <C-/>)
							-- actions.which_key shows the mappings for your picker,
							-- e.g. git_{create, delete, ...}_branch for the git_branches picker
							-- ["<C-h>"] = "which_key"
							-- ["<a-i>"] = Util.telescope("find_files", { no_ignore = true }),
							-- ["<a-h>"] = Util.telescope("find_files", { hidden = true }),
							["<C-j>"] = actions.move_selection_next,
							["<C-k>"] = actions.move_selection_previous,
							["<C-f>"] = actions.preview_scrolling_down,
							["<C-b>"] = actions.preview_scrolling_up,
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
						entry_formatter = function(tab_id, _, file_names, _)
							-- if vim.api.nvim_tabpage_is_valid(tab_id) then
							if next(fn.gettabinfo(tab_id)) ~= nil then
								-- local cwd = fn.getcwd(-1, tab_id)
								local cwd = vim.t[tab_id].root_dir or fn.getcwd(-1, tab_id)
								-- local root_dir = fn.substitute(cwd, '^.*/', '', '')
								local root_dir = fn.fnamemodify(cwd, ":t")
								return string.format("%d: %s, %s", tab_id, root_dir, cwd:gsub(vim.env.HOME, "~"))
							else
								local entry_string = table.concat(file_names, ", ")
								return string.format("%d: %s", tab_id, entry_string)
							end
						end,
						-- entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths)
						-- entry_ordinal = function(tab_id, _, file_names, _)
						-- 	local entry = table.concat(file_names, " ")
						-- 	return string.format("%d: %s", tab_id, entry)
						-- end,
						show_preview = true,
						close_tab_shortcut_i = "<C-d>", -- if you're in insert mode
						close_tab_shortcut_n = "D", -- if you're in normal mode
					},
				},
			}
		end,
	},
}
