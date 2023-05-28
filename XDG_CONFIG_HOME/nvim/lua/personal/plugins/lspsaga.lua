return {
  -- Improve LSP UI
  {
    "glepnir/lspsaga.nvim",
    -- cmd = "Lspsaga",
    event = "LspAttach",
    keys = {
      { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "Find the symbol definition" },

      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action", mode = { "n", "v" } },
      { "gr", "<cmd>Lspsaga rename<CR>", desc = "Reanme" },
      { "gR", "<cmd>Lspsaga rename ++project<CR>", desc = "Reanme" },

      { "gd", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
      { "gD", "<cmd>Lspsaga goto_definition<CR>", desc = "Goto definition" },

      { "gt", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Peek definition" },
      { "gT", "<cmd>Lspsaga goto_type_definition<CR>", desc = "Got definition" },

      { "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line diagnostics" },
      { "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Buffer diagnostics" },
      { "<leader>se", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Cursor diagnostics" },

      { "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", desc = "Prev diagnostic" },
      { "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", desc = "Next diagnostic" },

      {
        "[E",
        function()
          require("lspsaga.diagnostic"):goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Prev error diagnostics",
      },
      {
        "]E",
        function()
          require("lspsaga.diagnostic"):goto_next({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Next error diagnostics",
      },

      { "<leader>o", "<cmd>Lspsaga outline<CR>", desc = "Outline" },
      { "K", "<cmd>Lspsaga hover_doc ++keep<CR>", desc = "Hover doc" },

      { "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "Incoming calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing calls" },

      { "<leader>ft", "<cmd>Lspsaga term_toggle<CR>", mode = { "n", "t" }, desc = "Term toggle" },
    },
    opts = {
      finder = {
        keys = {
          edit = { "o", "<CR>" },
          vsplit = "<C-v>",
          split = "<C-x>",
          tabe = "t",
          quit = { "q", "<ESC>" },
        },
      },

      definition = {
        edit = "<C-c>o",
        vsplit = "<C-c>v",
        split = "<C-c>x",
        tabe = "<C-c>t",
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

      hover = {
        open_link = "<CR>",
      },

      diagnostic = {
        on_insert = true,
        on_insert_follow = true,
        show_code_action = true,
        show_source = true,
        jump_num_shortcut = true,
        keys = {
          exec_action = "o",
          quit = "q",
          go_action = "g",
          expand_or_jump = "<CR>",
          quit_in_show = { "q", "<ESC>" },
        },
      },

      rename = {
        quit = "<C-c>",
        exec = "<CR>",
        mark = "x",
        confirm = "<CR>",
        in_select = true,
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
          on_insert_follow = "o",
          quit = "q",
        },
      },

      callhierarchy = {
        show_detail = false,
        keys = {
          edit = "e",
          vsplit = "<C-v>",
          split = "<C-x>",
          tabe = "t",
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
        -- border type can be single,double,rounded,solid,shadow.
        border = "solid",
      },
    },
  },
}
