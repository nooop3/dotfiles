local lua_ls_library = vim.api.nvim_get_runtime_file("", true)
table.insert(
  lua_ls_library,
  -- fix undefined field warning
  vim.fn.stdpath("config") .. "/lua"
)

return {
  -- lspconfig
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      { "folke/neoconf.nvim", cmd = "Neoconf", config = true },
      { "folke/neodev.nvim", opts = { experimental = { pathStrict = true } } },
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      {
        "hrsh7th/cmp-nvim-lsp",
        cond = function()
          return require("util").has("nvim-cmp")
        end,
      },
      { "jose-elias-alvarez/typescript.nvim" },
      { "simrat39/rust-tools.nvim" },
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overridden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
      -- LSP Server Settings
      ---@type lspconfig.options
      servers = {
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        lua_ls = {
          -- mason = false, -- set to false if you don't want this server to be installed with mason
          settings = {
            Lua = {
              completion = {
                callSnippet = "Replace",
              },
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = lua_ls_library,
                checkThirdParty = false,
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        },
        clangd = {
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        bashls = {},
        tsserver = {
          settings = {
            javascript = {
              format = {
                semicolons = "remove",
              },
            },
            diagnostics = {
              ignoredCodes = {
                -- See https://github.com/microsoft/TypeScript/blob/master/src/compiler/diagnosticMessages.json for a full list of valid codes.
                -- Could not find a declaration file for module '{0}'. '{1}' implicitly has an 'any' type.
                7016,
                -- File is a CommonJS module; it may be converted to an ES module.
                80001,
              },
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
          init_options = {
            hostInfo = "neovim",
            disableAutomaticTypingAcquisition = false,
            preferences = {
              quotePreference = "single",
            },
          },
        },
        ["rust-analyzer"] = {
          cargo = {
            -- features = { "all" },
          },
          checkOnSave = {
            allTargets = false,
            -- default: `cargo check`
            command = "clippy",
          },
          imports = {
            granularity = {
              enforce = true,
            },
            prefix = "crate",
          },
          inlayHints = {
            lifetimeElisionHints = {
              enable = true,
              useParameterNames = true,
            },
          },
        },
        gopls = {
          settings = {
            gopls = {
              experimentalPostfixCompletions = true,
              analyses = {
                unusedparams = true,
                shadow = true,
              },
              staticcheck = true,
            },
          },
          init_options = {
            usePlaceholders = true,
          },
        },
        -- tflint = {
        -- 	-- root_pattern(".terraform", ".git", ".tflint.hcl")
        -- 	root_dir = require("lspconfig").util.root_pattern(".git", ".tflint.hcl"),
        -- },
        -- terraformls = {
        -- 	-- root_pattern(".terraform", ".git", ".tflint.hcl")
        -- 	root_dir = require("lspconfig").util.root_pattern(".git", ".tflint.hcl"),
        -- },
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      ---@type table<string, fun(server:string, opts:_.lspconfig.options):boolean?>
      setup = {
        tsserver = function(_, opts)
          require("util").on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
            end
          end)
          require("typescript").setup({ server = opts })
          require("rust-tools").setup({ server = opts })
          return true
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      require("plugins.lsp.format").autoformat = opts.autoformat
      -- setup formatting and keymaps
      require("util").on_attach(function(client, buffer)
        require("plugins.lsp.format").on_attach(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      -- diagnostics
      vim.diagnostic.config(opts.diagnostics)

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())

      local function setup(server)
        local server_opts = vim.tbl_deep_extend("force", {
          capabilities = vim.deepcopy(capabilities),
        }, servers[server] or {})

        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      -- get all the servers that are available thourgh mason-lspconfig
      local have_mason, mlsp = pcall(require, "mason-lspconfig")
      local all_mslp_servers = {}
      if have_mason then
        all_mslp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
      end

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(all_mslp_servers, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      if have_mason then
        mlsp.setup({ ensure_installed = ensure_installed })
        mlsp.setup_handlers({ setup })
      end
    end,
  },

  -- null_ls
  {
    "jose-elias-alvarez/null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local null_ls = require("null-ls")

      -- for conciseness
      local diagnostics = null_ls.builtins.diagnostics
      local formatting = null_ls.builtins.formatting
      local code_actions = null_ls.builtins.code_actions

      -- to setup format on save
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      return {
        root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
        sources = {
          -- setup code actions
          -- filetypes: "javascript", "javascriptreact", "typescript", "typescriptreact", "vue"
          -- code_actions.eslint_d,
          require("typescript.extensions.null-ls.code-actions"),
          -- filetypes: "sh"
          code_actions.shellcheck,
          -- code_actions.gitsigns,

          -- filetypes: "proto"
          -- install: yay -S protolint
          diagnostics.protolint,
          -- filetypes: "sh"
          diagnostics.shellcheck,
          -- filetypes: "sql"
          -- install: sudo pacman -S sqlfluff
          diagnostics.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          -- filetypes: "markdown", "tex", "asciidoc"
          diagnostics.vale,
          -- filetypes: "yaml"
          diagnostics.yamllint,

          -- setup code formatters
          formatting.stylua,
          formatting.shfmt,
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
          formatting.sqlfluff.with({
            extra_args = { "--dialect", "postgres" }, -- change to your dialect
          }),
          --[[ -- filetypes: "sql", "pgsql"
        -- install: sudo pacman -S pgformatter
        formatting.pg_format.with({
        extra_args = {
        "--keep-newline",
        "--no-extra-line",
        "--redshift",
        "--keyword-case=0",
        -- "--extra-function=" .. vim.env.HOME .. "/.config/pg_format/functions.lst",
        "--extra-function=" .. vim.fn.expand("$HOME/.config/pg_format/functions.lst"),
        },
        }), ]]
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
      }
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
      ensure_installed = {
        "json-lsp",
        "stylua",
        "shfmt",
        -- "flake8",
        "pyright",
      },
    },
    ---@param opts MasonSettings | {ensure_installed: string[]}
    config = function(_, opts)
      require("mason").setup(opts)
      local mr = require("mason-registry")
      local function ensure_installed()
        for _, tool in ipairs(opts.ensure_installed) do
          local p = mr.get_package(tool)
          if not p:is_installed() then
            p:install()
          end
        end
      end
      if mr.refresh then
        mr.refresh(ensure_installed)
      else
        ensure_installed()
      end
    end,
  },
  -- Improve LSP UI
  {
    "glepnir/lspsaga.nvim",
    cmd = "Lspsaga",
    keys = {
      -- Lsp finder find the symbol definition implement reference
      -- if there is no implement it will hide
      -- when you use action in finder like open vsplit then you can
      -- use <C-t> to jump back
      { "gh", "<cmd>Lspsaga lsp_finder<CR>", desc = "find the symbol definition implement reference" },

      -- Rename
      { "<leader>cr", "<cmd>Lspsaga rename<CR>", desc = "reanme" },

      -- Peek Definition
      -- you can edit the definition file in this flaotwindow
      -- also support open/vsplit/etc operation check definition_action_keys
      -- support tagstack C-t jump back
      -- keymap("n", "gd", "<cmd>Lspsaga peek_definition<CR>")
      { "gd", "<cmd>Lspsaga peek_definition<CR>", desc = "Goto Definition" },
      -- Go to Definition
      { "gD", "<cmd>Lspsaga goto_definition<CR>", desc = "Goto Definition" },

      -- Show line diagnostics you can pass argument ++unfocus to make
      -- show_line_diagnostics float window unfocus
      { "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", desc = "Line Diagnostics" },

      -- Show cursor diagnostic
      -- also like show_line_diagnostics  support pass ++unfocus
      { "<leader>cD", "<cmd>Lspsaga show_cursor_diagnostics<CR>", desc = "Cursor Diagnostics" },

      -- Show buffer diagnostic
      { "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", desc = "Buffer Diagnostics" },

      -- Diagnostic jump with filter like Only jump to error
      {
        "[E",
        function()
          require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Prev Error Diagnostics",
      },
      {
        "]E",
        function()
          require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end,
        desc = "Next Error Diagnostics",
      },

      -- Toggle Outline
      { "<leader>o", "<cmd>Lspsaga outline<CR>", desc = "outline" },

      -- Callhierarchy
      { "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", desc = "Incoming calls" },
      { "<leader>co", "<cmd>Lspsaga outgoing_calls<CR>", desc = "Outgoing calls" },

      -- Float terminal
      { "<A-d>", "<cmd>Lspsaga term_toggle<CR>", mode = { "n", "t" }, desc = "Term toggle" },

      -- -- Float terminal
      -- local augroup = vim.api.nvim_create_augroup
      -- local autocmd = vim.api.nvim_create_autocmd

      -- local term = require("lspsaga.floaterm")
      -- keymap("n", "<leader>tt", "<cmd>Lspsaga open_floaterm<CR>", { silent = true })
      -- if you want pass somc cli command into terminal you can do like this
      -- open lazygit in lspsaga float terminal
      -- keymap("n", "<leader>tt", "<cmd>Lspsaga open_floaterm lazygit<CR>", { silent = true })
      -- close floaterm
      -- keymap("t", "<leader>tt", [[<C-\><C-n><cmd>Lspsaga close_floaterm<CR>]], { silent = true })
    },
    config = function()
      local saga = require("lspsaga")

      saga.setup({
        -- when cursor in saga window you config these to move
        preview = {
          lines_above = 0,
          lines_below = 10,
        },
        scroll_preview = {
          -- scroll_down = "<C-f>",
          -- scroll_up = "<C-b>",
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
    end,
  },
}
