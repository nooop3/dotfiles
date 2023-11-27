return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "jose-elias-alvarez/typescript.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set( "n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    opts = {
      servers = {
        clangd = {
          -- enabled = false,
          -- disabled_filetypes = { "proto" },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        tsserver = {
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
            diagnostics = {
              ignoredCodes = {
                -- See https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json for a full list of valid codes.
                -- Initializer provides no value for this binding element and the binding element has no default value.
                2525,
                -- Could not find a declaration file for module '{0}'. '{1}' implicitly has an 'any' type.
                7016,
                -- Parameter '{0}' implicitly has an '{1}' type, but a better type may be inferred from usage.
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
          },
        },
      },
      setup = {
        tsserver = function(_, opts)
          require("typescript").setup({ server = opts })
          return true
        end,
      },
    },
  },
}
