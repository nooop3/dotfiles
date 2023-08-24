local Util = require("personal.util")

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

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "jose-elias-alvarez/typescript.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.tsserver
        tsserver = {
          keys = {
            { "<leader>co", "<cmd>TypescriptOrganizeImports<CR>", desc = "Organize Imports" },
            { "<leader>cR", "<cmd>TypescriptRenameFile<CR>", desc = "Rename File" },
          },
          settings = {
            typescript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
              },
            },
            javascript = {
              format = {
                indentSize = vim.o.shiftwidth,
                convertTabsToSpaces = vim.o.expandtab,
                tabSize = vim.o.tabstop,
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
          capabilities = {
            documentFormattingProvider = false,
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
        },
        eslint = {
          settings = {
            -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
            workingDirectory = { mode = "auto" },
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
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
      table.insert(opts.sources, require("typescript.extensions.null-ls.code-actions"))
    end,
    -- opts = function(_, opts)
    --   local nls = require("null-ls")
    --   vim.list_extend(opts.sources, {
    --     require("typescript.extensions.null-ls.code-actions"),
    --     nls.builtins.code_actions.eslint.with({
    --       condition = function(utils)
    --         return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
    --       end,
    --     }),
    --     nls.builtins.diagnostics.eslint.with({
    --       condition = function(utils)
    --         return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
    --       end,
    --     }),
    --     nls.builtins.formatting.eslint.with({
    --       condition = function(utils)
    --         return utils.root_has_file({ ".eslintrc", ".eslintrc.js", ".eslintrc.cjs", ".eslintrc.json" })
    --       end,
    --     }),
    --     -- nls.builtins.formatting.prettierd.with({
    --     --   condition = function(utils)
    --     --     return utils.root_has_file({ ".prettierrc", ".prettierrc.json" })
    --     --   end,
    --     -- }),
    --   })
    -- end,
  },
}
