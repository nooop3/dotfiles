return {
  { "sainnhe/gruvbox-material" },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
      -- colorscheme = "gruvbox-material",
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      gitbrowse = {
        url_patterns = {
          -- default to gitlab url patterns
          ["git%..+"] = {
            branch = "/-/tree/{branch}",
            file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
            commit = "/-/commit/{commit}",
          },
        },
      },
    },
  },
}
