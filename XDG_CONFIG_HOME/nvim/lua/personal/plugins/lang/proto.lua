local Util = require("personal.util")

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
          cwd = function()
            return Util.get_root()
          end,
          args = function()
            if vim.fn.filereadable(".protolint.yaml") ~= 0 then
              return {
                "-config_path",
                ".protolint.yaml",
                "-reporter",
                "json",
                "$FILENAME",
              }
            else
              return {
                "-reporter",
                "json",
                "$FILENAME",
              }
            end
          end,
        }),
        nls.builtins.formatting.protolint.with({
          -- diagnostics_format = "[#{c}] #{m} (#{s})",
          cwd = function()
            return Util.get_root()
          end,
          args = function()
            if vim.fn.filereadable(".protolint.yaml") ~= 0 then
              return {
                "-config_path",
                ".protolint.yaml",
                "-fix",
                "$FILENAME",
              }
            else
              return {
                "-fix",
                "$FILENAME",
              }
            end
          end,
        }),
      })
    end,
  },
}
