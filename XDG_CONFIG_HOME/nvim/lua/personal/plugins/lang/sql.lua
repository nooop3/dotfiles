return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "sql" })
      end
    end,
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, { "sqlfluff" })
    end,
  },
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.sqlfluff.with({
          extra_args = { "--dialect", "postgres" }, -- change to your dialect
          -- method = nls.methods.DIAGNOSTICS_ON_SAVE,
        }),
        nls.builtins.formatting.sqlfluff.with({
          extra_args = { "--dialect", "postgres" }, -- change to your dialect
          -- method = nls.methods.DIAGNOSTICS_ON_SAVE,
        }),
        -- nls.builtins.formatting.pg_format.with({
        --   extra_args = {
        --     "--keep-newline",
        --     "--no-extra-line",
        --     "--redshift",
        --     "--keyword-case=0",
        --     -- "--extra-function=" .. vim.env.HOME .. "/.config/pg_format/functions.lst",
        --     "--extra-function=" .. vim.fn.expand("$HOME/.config/pg_format/functions.lst"),
        --   },
        -- }),
      })
    end,
  },
}
