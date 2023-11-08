return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  opts = {
    indent = { char = "▎" },
    whitespace = {
      -- highlight = { "Whitespace", "NonText" },
      remove_blankline_trail = true,
    },
    exclude = {
      filetypes = {
        "lspinfo",
        "packer",
        "checkhealth",
        "man",
        "gitcommit",
        "TelescopePrompt",
        "TelescopeResults",
        "",
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
      },
    },
  },
}
