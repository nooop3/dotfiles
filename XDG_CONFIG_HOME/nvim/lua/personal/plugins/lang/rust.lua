return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "rust" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    dependencies = { "simrat39/rust-tools.nvim" },
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.rust_analyzer
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
      },
      setup = {
        rust_analyzer = function(_, opts)
          require("rust-tools").setup({ server = opts })
        end,
      },
    },
  },
}
