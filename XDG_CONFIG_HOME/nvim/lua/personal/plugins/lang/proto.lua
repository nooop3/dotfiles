return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "proto" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "protolint" })
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.protolint.with({
          -- diagnostics_format = "[#{c}] #{m} (#{s})",
          args = {
            "-config_path",
            vim.loop.cwd() .. "/.protolint.yaml",
            "-reporter",
            "json",
            "$FILENAME",
          },
        }),
        nls.builtins.formatting.protolint.with({
          -- diagnostics_format = "[#{c}] #{m} (#{s})",
          args = {
            "-config_path",
            vim.loop.cwd() .. "/.protolint.yaml",
            "-reporter",
            "json",
            "$FILENAME",
          },
        }),
      })
    end,
  },
}
