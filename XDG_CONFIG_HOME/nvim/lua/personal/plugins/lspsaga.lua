return {
  -- Improve LSP UI
  {
    "nvimdev/lspsaga.nvim",
    commit = "4cad6da6e05b7651ca8f66ec1fb3a824395ada68",
    -- cmd = "Lspsaga",
    event = "LspAttach",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    keys = {
      { "gh", "<cmd>Lspsaga finder<CR>", desc = "Find the symbol definition" },

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

      { "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line diagnostics" },
      { "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Buffer diagnostics" },
      { "<leader>se", "<cmd>Lspsaga show_workspace_diagnostics<CR>", desc = "Workspace diagnostics" },
      { "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Cursor diagnostics" },

      { "gd", "<cmd>Lspsaga peek_definition<CR>", desc = "Peek definition" },
      { "gD", "<cmd>Lspsaga goto_definition<CR>", desc = "Goto definition" },

      { "gt", "<cmd>Lspsaga peek_type_definition<CR>", desc = "Peek definition" },
      { "gT", "<cmd>Lspsaga goto_type_definition<CR>", desc = "Got definition" },

      -- { "K", "<cmd>Lspsaga hover_doc ++keep<CR>", desc = "Hover doc" },
      { "K", "<cmd>Lspsaga hover_doc<CR>", desc = "Hover doc" },

      { "gr", "<cmd>Lspsaga rename<CR>", desc = "Reanme" },
      { "gR", "<cmd>Lspsaga rename ++project<CR>", desc = "Reanme" },

      { "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "Incoming calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing calls" },

      { "<leader>ca", "<cmd>Lspsaga code_action<CR>", desc = "Code Action", mode = { "n", "v" } },

      { "<leader>o", "<cmd>Lspsaga outline<CR>", desc = "Outline" },

      { "<leader>ft", "<cmd>Lspsaga term_toggle<CR>", mode = { "n", "t" }, desc = "Term toggle" },
    },
    opts = {
      finder = {
        keys = {
          shuttle = "[w",
          toggle_or_open = "o",
          edit = { "o", "<CR>" },
          vsplit = "<C-v>",
          split = "<C-x>",
          tabe = "t",
          tabnew = "r",
          quit = { "q", "<ESC>" },
          close = "<C-c>k",
        },
      },

      diagnostic = {
        show_code_action = true,
        jump_num_shortcut = true,
        text_hl_follow = true,
        border_follow = true,
        keys = {
          exec_action = "o",
          quit = "q",
          toggle_or_jump = "<CR>",
          quit_in_show = { "q", "<ESC>" },
        },
      },

      definition = {
        keys = {
          edit = "<C-c>o",
          vsplit = "<C-c>v",
          split = "<C-c>x",
          tabe = "<C-c>t",
          quit = "q",
          close = "<C-c>k",
        },
      },

      hover = {
        open_link = "<CR>",
      },

      rename = {
        in_select = true,
        auto_save = true,
        keys = {
          quit = "<C-c>",
          exec = "<CR>",
          select = "x",
        },
      },

      callhierarchy = {
        show_detail = false,
        keys = {
          edit = "e",
          vsplit = "<C-v>",
          split = "<C-x>",
          tabe = "t",
          quit = "q",
          shuttle = "[w",
          toggle_or_req = "u",
          close = "<C-c>k",
        },
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
        sign = true,
        virtual_text = true,
        debounce = 10,
        sign_priority = 40,
      },

      symbol_in_winbar = {
        enable = true,
        separator = " ",
        hide_keyword = true,
        show_file = true,
        folder_level = 2,
        color_mode = true,
        delay = 300,
      },

      outline = {
        win_position = "right",
        win_width = 30,
        auto_preview = true,
        detail = true,
        auto_close = true,
        close_after_jump = false,
        keys = {
          toggle_or_jump = "o",
          quit = "q",
          jump = "e",
        },
      },

      implement = {
        enable = true,
        sign = true,
        virtual_text = true,
        priority = 100,
      },

      ui = {
        -- border type can be single,double,rounded,solid,shadow.
        border = "solid",
        devicon = true,
        title = true,
        imp_sign = "󰳛 ",
      },
    },
  },
}
