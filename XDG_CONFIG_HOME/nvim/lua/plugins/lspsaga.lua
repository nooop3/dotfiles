return {
  {
    -- Improve LSP UI
    "glepnir/lspsaga.nvim",
    config = function ()
      -- import lspsaga safely
      local saga_status, sage = pcall(require, "lspsaga")
      if not saga_status then
        return
      end
      local keymap = vim.keymap.set

      sage.setup({
        -- when cursor in saga window you config these to move
        preview = {
          lines_above = 0,
          lines_below = 10,
        },
        scroll_preview = {
          scroll_down = "<C-f>",
          scroll_up = "<C-b>",
        },
        request_timeout = 2000,

        finder = {
          keys = {
            edit = { "o", "<CR>" },
            vsplit = "<C-v>",
            split = "<C-x>",
            tab = "t",
            quit = { "q", "<ESC>" },
          },
        },

        definition = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>x",
          tab = "<C-c>t",
          quit = "q",
        },

        code_action = {
          num_shortcut = true,
          show_server_name = true,
          extend_gitsigns = false,
          keys = {
            -- string |table type
            quit = "q",
            exec = "<CR>",
          },
        },

        lightbulb = {
          enable = true,
          enable_in_insert = true,
          sign = true,
          sign_priority = 40,
          virtual_text = true,
        },

        diagnostic = {
          show_code_action = true,
          show_source = true,
          jump_num_shortcut = true,
          keys = {
            exec_action = "o",
            quit = "q",
            go_action = "g",
          },
        },

        rename = {
          quit = "<C-c>",
          exec = "<CR>",
          mark = "x",
          confirm = "<CR>",
          in_select = true,
          whole_project = true,
        },

        outline = {
          win_position = "right",
          win_with = "",
          win_width = 30,
          show_detail = true,
          auto_preview = true,
          auto_refresh = true,
          auto_close = true,
          custom_sort = nil,
          keys = {
            jump = "o",
            expand_collapse = "u",
            quit = "q",
          },
        },

        callhierarchy = {
          show_detail = false,
          keys = {
            edit = "e",
            vsplit = "<C-v>",
            split = "<C-x>",
            tab = "t",
            jump = "o",
            quit = "q",
            expand_collapse = "u",
          },
        },

        symbol_in_winbar = {
          enable = true,
          separator = " ",
          hide_keyword = true,
          show_file = true,
          folder_level = 2,
          respect_root = false,
          color_mode = true,
        },

        ui = {
          -- currently only round theme
          theme = "round",
          -- border type can be single,double,rounded,solid,shadow.
          border = "solid",
          winblend = 0,
          expand = "",
          collapse = "",
          preview = " ",
          code_action = "💡",
          diagnostic = "🐞",
          incoming = " ",
          outgoing = " ",
          colors = {
            --float window normal background color
            normal_bg = "#1d1536",
            --title background color
            title_bg = "#afd700",
            red = "#e95678",
            magenta = "#b33076",
            orange = "#FF8700",
            yellow = "#f7bb3b",
            green = "#afd700",
            cyan = "#36d0e0",
            blue = "#61afef",
            purple = "#CBA6F7",
            white = "#d1d4cf",
            black = "#1c1c19",
          },
          kind = {},
        },

        move_in_saga = { prev = "<C-k>", next = "<C-j>" },
      })

      -- Lsp finder find the symbol definition implement reference
      -- if there is no implement it will hide
      -- when you use action in finder like open vsplit then you can
      -- use <C-t> to jump back
      keymap("n", "gh", "<cmd>Lspsaga lsp_finder<CR>")

      -- Code action
      keymap({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>")

      -- Rename
      keymap("n", "gr", "<cmd>Lspsaga rename<CR>")

      -- Peek Definition
      -- you can edit the definition file in this flaotwindow
      -- also support open/vsplit/etc operation check definition_action_keys
      -- support tagstack C-t jump back
      keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")

      -- Go to Definition
      keymap("n", "gD", "<cmd>Lspsaga goto_definition<CR>")

      -- Show line diagnostics you can pass argument ++unfocus to make
      -- show_line_diagnostics float window unfocus
      keymap("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>")

      -- Show cursor diagnostic
      -- also like show_line_diagnostics  support pass ++unfocus
      keymap("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>")

      -- Show buffer diagnostic
      keymap("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>")

      -- Diagnostic jump can use `<c-o>` to jump back
      keymap("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>")
      keymap("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>")

      -- Diagnostic jump with filter like Only jump to error
      keymap("n", "[E", function()
        require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end)
      keymap("n", "]E", function()
        require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
      end)

      -- Toggle Outline
      keymap("n", "<leader>o", "<cmd>Lspsaga outline<CR>")

      -- Hover Doc
      -- if there has no hover will have a notify no information available
      -- to disable it just Lspsaga hover_doc ++quiet
      keymap("n", "K", "<cmd>Lspsaga hover_doc<CR>")

      -- Callhierarchy
      keymap("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>")
      keymap("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>")

      -- Float terminal
      keymap({ "n", "t" }, "<A-d>", "<cmd>Lspsaga term_toggle<CR>")

      -- -- Float terminal
      -- local augroup = vim.api.nvim_create_augroup
      -- local autocmd = vim.api.nvim_create_autocmd

      -- local term = require("lspsaga.floaterm")
      -- keymap("n", "<leader>tt", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
      -- -- if you want pass somc cli command into terminal you can do like this
      -- -- open lazygit in lspsaga float terminal
      -- -- keymap("n", "<leader>tt", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
      -- -- close floaterm
      -- keymap("t", "<leader>tt", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })

      -- -- Auto close terminal
      -- local auto_close_terminal = augroup("AutoCloseTerminal", { clear = true })
      -- autocmd({ "TermClose" }, {
      -- 	group = auto_close_terminal,
      -- 	pattern = { "*" },
      -- 	callback = function()
      -- 		-- local current_bufnr = vim.fn.expand("<abuf>")
      -- 		local current_bufnr = vim.api.nvim_get_current_buf()
      -- 		if term.term_bufnr == current_bufnr then
      -- 			term.first_open = nil
      -- 			vim.api.nvim_buf_delete(term.term_bufnr, { force = true })
      -- 			term.term_bufnr, term.term_winid = nil, nil
      -- 			vim.api.nvim_buf_delete(term.shadow_bufnr, { force = true })
      -- 			term.shadow_bufnr, term.shadow_winid = nil, nil
      -- 		else
      -- 			return vim.fn.execute("bdelete! " .. current_bufnr)
      -- 		end
      -- 	end,
      -- })
    end
  }
}
