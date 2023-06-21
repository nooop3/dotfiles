local Util = require("personal.util")

return {
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
        },
        -- eslint = {
        --   settings = {
        --     -- helps eslint find the eslintrc when it's placed in a subfolder instead of the cwd root
        --     workingDirectory = { mode = "auto" },
        --   },
        -- },
      },
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
        eslint = function()
          vim.api.nvim_create_autocmd("BufWritePre", {
            callback = function(event)
              if require("lspconfig.util").get_active_client_by_name(event.buf, "eslint") then
                vim.cmd("EslintFixAll")
              end
            end,
          })
        end,
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "eslint_d", "prettierd" })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        require("typescript.extensions.null-ls.code-actions"),
        nls.builtins.code_actions.eslint_d,
        nls.builtins.diagnostics.eslint_d,
        nls.builtins.formatting.eslint_d,
        -- nls.builtins.formatting.prettierd
      })
    end,
  },
}
