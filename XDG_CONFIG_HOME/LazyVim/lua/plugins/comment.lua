return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  opts = function()
    local ft = require("Comment.ft")

    ft.set("sbt", { "//%s", "/*%s*/" })
    ft.set("hocon", { "#%s" })
    return {
      ignore = "^$",
    }
  end,
}
