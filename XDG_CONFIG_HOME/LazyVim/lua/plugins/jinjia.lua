return {
  { "Glench/Vim-Jinja2-Syntax", ft = { "jinja", "jinja2", "htmljinja", "htmldjango" } },

  {
    "nvim-lua/plenary.nvim",
    init = function()
      vim.filetype.add({
        extension = {
          j2 = "jinja",
          jinja = "jinja",
          jinja2 = "jinja",
        },
        pattern = {
          [".*%.html%.j2"] = "htmldjango",
          [".*%.html%.jinja2?"] = "htmldjango",
        },
      })
    end,
  },
}
