return {
  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    opts = function()
      local ft = require("Comment.ft")

      ft.set("sbt", { "//%s", "/*%s*/" })
      ft.set("hocon", { "#%s" })
      return {
        ignore = "^$",
        pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
      }
    end,
  },
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
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      highlight = {
        multiline = false,
        after = "",
      },
    },
  },
}
