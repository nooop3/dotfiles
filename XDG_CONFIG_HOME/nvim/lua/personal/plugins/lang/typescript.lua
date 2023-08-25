return {

  -- add typescript to treesitter
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "typescript", "tsx", "javascript" })
      end
    end,
  },

  -- typescript-tools
  -- {
  --   "neovim/nvim-lspconfig",
  --   dependencies = { "pmizio/typescript-tools.nvim" },
  --   opts = {
  --     -- make sure mason installs the server
  --     servers = {
  --       tsserver = {
  --         settings = {
  --           expose_as_code_action = {
  --             "fix_all",
  --             "remove_unused",
  --             "add_missing_imports",
  --           },
  --           tsserver_file_preferences = {
  --             quotePreference = "single",
  --             -- importModuleSpecifierEnding = "js",
  --             importModuleSpecifierEnding = "auto",
  --           },
  --           tsserver_format_options = {},
  --         },
  --       },
  --     },
  --     setup = {
  --       ---@diagnostic disable-next-line: unused-local
  --       tsserver = function(_, opts)
  --         local api = require("typescript-tools.api")
  --         require("typescript-tools").setup({
  --           handlers = {
  --             ["textDocument/publishDiagnostics"] = api.filter_diagnostics({
  --               -- Could not find a declaration file for module '{0}'. '{1}' implicitly has an 'any' type.
  --               -- 7016,
  --               -- File is a CommonJS module; it may be converted to an ES module.
  --               80001,
  --               -- Ignore 'This may be converted to an async function' diagnostics.
  --               -- 80006
  --             }),
  --           },
  --           settings = opts.settings,
  --         })
  --         return true
  --       end,
  --     },
  --   },
  -- },

  -- typescript
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        tsserver = {
          keys = {
            { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
            { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
          },
          capabilities = {
            -- documentFormattingProvider = false,
          },
          init_options = {
            hostInfo = "neovim",
            disableAutomaticTypingAcquisition = false,
            preferences = {
              quotePreference = "single",
              -- importModuleSpecifierEnding = "js",
              importModuleSpecifierEnding = "auto",
            },
            -- tsserver = {
            --   logDirectory = vim.fn.expand("~/.cache/nvim/"),
            --   logVerbosity = "verbose",
            -- },
          },
          settings = {
            javascript = {
              format = {
                -- indentSize = vim.o.shiftwidth,
                -- convertTabsToSpaces = vim.o.expandtab,
                -- tabSize = vim.o.tabstop,
                semicolons = "remove",
              },
            },
            typescript = {
              format = {
                -- indentSize = vim.o.shiftwidth,
                -- convertTabsToSpaces = vim.o.expandtab,
                -- tabSize = vim.o.tabstop,
              },
            },
            diagnostics = {
              ignoredCodes = {
                -- See https://github.com/microsoft/TypeScript/blob/master/src/compiler/diagnosticMessages.json for a full list of valid codes.
                -- Could not find a declaration file for module '{0}'. '{1}' implicitly has an 'any' type.
                7016,
                -- Parameter '{0}' implicitly has an 'any' type, but a better type may be inferred from usage.
                7044,
                -- File is a CommonJS module; it may be converted to an ES module.
                80001,
              },
            },
            implicitProjectConfiguration = {
              checkJs = true,
              experimentalDecorators = true,
              -- implicitProjectConfiguration = "ESNext",
            },
            completions = {
              completeFunctionCalls = true,
            },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({
            server = opts,
          })
          return true
        end,
      },
    },
  },

  -- eslint
  {
    "neovim/nvim-lspconfig",
    -- other settings removed for brevity
    opts = {
      ---@type lspconfig.options
      servers = {
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
      },
      setup = {
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if not require("personal.plugins.lsp.format").enabled() then
                -- exit early if autoformat is not enabled
                return
              end

              local client = vim.lsp.get_active_clients({ bufnr = event.buf, name = "eslint" })[1]
              if client then
                local diag = vim.diagnostic.get(event.buf, { namespace = vim.lsp.diagnostic.get_namespace(client.id) })
                if #diag > 0 then
                  vim.cmd("EslintFixAll")
                end
              end
            end,
          })
        end,
      },
    },
  },

  -- {
  --   "williamboman/mason.nvim",
  --   opts = function(_, opts)
  --     vim.list_extend(opts.ensure_installed, { "eslint_d", "prettierd" })
  --   end,
  -- },

  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        require("typescript.extensions.null-ls.code-actions"),
        nls.builtins.code_actions.eslint.with({
          only_local = "node_modules/.bin",
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
          end,
        }),
        nls.builtins.diagnostics.eslint.with({
          only_local = "node_modules/.bin",
          condition = function(utils)
            return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
          end,
        }),
        -- nls.builtins.formatting.prettierd.with({
        --   condition = function(utils)
        --     return utils.root_has_file({ ".prettierrc", ".prettierrc.json" })
        --   end,
        -- }),
      })
    end,
  },
}
