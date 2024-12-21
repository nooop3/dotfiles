return {
  -- neogen
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    -- Uncomment next line if you want to follow only stable versions
    -- version = "*"
    keys = {
      {
        "<leader>nf",
        function()
          require("neogen").generate({ type = "func" })
        end,
        desc = "Generate function docstring",
      },
      {
        "<leader>nc",
        function()
          require("neogen").generate({ type = "class" })
        end,
        desc = "Generate class docstring",
      },
      {
        "<leader>nt",
        function()
          require("neogen").generate({ type = "type" })
        end,
        desc = "Generate type docstring",
      },
      {
        "<leader>nF",
        function()
          require("neogen").generate({ type = "file" })
        end,
        desc = "Generate file docstring",
      },
    },
    opts = {
      snippet_engine = "luasnip",
    },
  },
}
