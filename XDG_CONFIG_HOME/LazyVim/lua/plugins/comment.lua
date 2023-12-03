return {
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
}
