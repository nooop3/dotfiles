return {
  -- colorscheme
  { "sainnhe/gruvbox-material" },

  {
    "LazyVim/LazyVim",
    opts = {
      -- colorscheme = "catppuccin-mocha",
      -- colorscheme = "gruvbox-material",
    },
  },

  {
    "folke/snacks.nvim",
    opts = {
      gitbrowse = {
        config = function(opts, _)
          table.insert(opts.remote_patterns, 1, { "^git@ssh%.(.+):(.+)%.git$", "https://git.%1/%2" })
          opts.url_patterns = {
            -- default to gitlab url patterns
            ["git%..+"] = {
              branch = "/-/tree/{branch}",
              file = "/-/blob/{branch}/{file}#L{line_start}-L{line_end}",
              commit = "/-/commit/{commit}",
            },
          }
        end,
      },
    },
  },
}
