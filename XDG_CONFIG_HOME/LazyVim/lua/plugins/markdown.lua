local markdown_ft = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" }

local global_cfg = vim.fn.expand("~/.config/markdownlint/.markdownlint-cli2.jsonc")
local cfg_args = vim.fn.filereadable(global_cfg) == 1 and { "--config", global_cfg } or {}

return {
  {
    "OXY2DEV/markview.nvim",
    enabled = false,
    lazy = false,
    ft = markdown_ft,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      filetypes = markdown_ft,
    },
  },

  -- LINTING (nvim-lint) with markdownlint-cli2
  {
    "mfussenegger/nvim-lint",
    opts = function(_, opts)
      opts.linters = {
        ["markdownlint-cli2"] = {
          prepend_args = cfg_args,
        },
      }
    end,
  },

  -- FORMATTING (conform.nvim) using markdownlint-cli2 --fix
  {
    "stevearc/conform.nvim",
    opts = function(_, opts)
      opts.formatters = {
        ["markdownlint-cli2"] = {
          prepend_args = cfg_args,
        },
      }
    end,
  },
}
