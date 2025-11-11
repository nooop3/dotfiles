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
        remote_patterns = {
          -- custom open url
          { "^git@ssh%.(.+):(.+)%.git$", "https://git.%1/%2" },

          { "^(https?://.*)%.git$", "%1" },
          { "^git@(.+):(.+)%.git$", "https://%1/%2" },
          { "^git@(.+):(.+)$", "https://%1/%2" },
          { "^git@(.+)/(.+)$", "https://%1/%2" },
          { "^org%-%d+@(.+):(.+)%.git$", "https://%1/%2" },
          { "^ssh://git@(.*)$", "https://%1" },
          { "^ssh://([^:/]+)(:%d+)/(.*)$", "https://%1/%3" },
          { "^ssh://([^/]+)/(.*)$", "https://%1/%2" },
          { "ssh%.dev%.azure%.com/v3/(.*)/(.*)$", "dev.azure.com/%1/_git/%2" },
          { "^https://%w*@(.*)", "https://%1" },
          { "^git@(.*)", "https://%1" },
          { ":%d+", "" },
          { "%.git$", "" },
        },
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
