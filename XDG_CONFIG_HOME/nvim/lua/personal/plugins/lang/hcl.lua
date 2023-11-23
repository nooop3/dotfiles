return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "hcl", "terraform" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.pyright
        tflint = {
          -- root_pattern(".terraform", ".git", ".tflint.hcl")
          root_dir = require("lspconfig").util.root_pattern(".git", ".tflint.hcl"),
        },
        -- terraformls = {
        --   -- root_pattern(".terraform", ".git", ".tflint.hcl")
        --   root_dir = require("lspconfig").util.root_pattern(".git", ".tflint.hcl"),
        -- },
      },
    },
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.terraform_fmt,
      })
    end,
  },
}
