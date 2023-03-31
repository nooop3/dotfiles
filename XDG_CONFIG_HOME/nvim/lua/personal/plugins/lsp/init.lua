local Util = require("personal.util")

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
          return Util.has("nvim-cmp")
        end,
      },
      { "jose-elias-alvarez/typescript.nvim" },
      { "simrat39/rust-tools.nvim" },
    },
    ---@class PluginLspOpts
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
        rust_analyzer = {
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
          Util.on_attach(function(client, buffer)
            if client.name == "tsserver" then
              -- stylua: ignore
              vim.keymap.set("n", "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", { buffer = buffer, desc = "Organize Imports" })
              -- stylua: ignore
              vim.keymap.set("n", "<leader>cR", "<cmd>TypescriptRenameFile<CR>", { desc = "Rename File", buffer = buffer })
            end
          end)
          require("typescript").setup({ server = opts })
          return true
        end,
        rust_analyzer = function(_, opts)
          require("rust-tools").setup({ server = opts })
        end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
    },
    ---@param opts PluginLspOpts
    config = function(_, opts)
      -- setup autoformat
      require("personal.plugins.lsp.format").autoformat = opts.autoformat
      -- setup formatting and keymaps
      Util.on_attach(function(client, buffer)
        require("personal.plugins.lsp.format").on_attach(client, buffer)
        require("personal.plugins.lsp.keymaps").on_attach(client, buffer)
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
}
