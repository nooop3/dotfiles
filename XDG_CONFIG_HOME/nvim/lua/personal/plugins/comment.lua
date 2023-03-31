return {
  "numToStr/Comment.nvim",
  event = "VeryLazy",
  opts = function()
    local ft = require("Comment.ft")

    ft.set("sbt", { "//%s", "/*%s*/" })
    ft.set("hocon", { "#%s" })
    return {
      padding = true,
      sticky = true,
      ignore = "^$",
      toggler = {
        line = "gcc",
        block = "gbc",
      },
      opleader = {
        line = "gc",
        block = "gb",
      },
      extra = {
        above = "gcO",
        below = "gco",
        eol = "gcA",
      },
      mappings = {
        basic = true,
        extra = true,
      },
      pre_hook = nil,
      post_hook = nil,
    }
  end,
}
