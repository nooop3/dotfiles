local markdown_ft = { "markdown", "norg", "rmd", "org", "vimwiki", "Avante" }

return {
  "OXY2DEV/markview.nvim",
  enabled = false,
  lazy = false,
  ft = markdown_ft,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    filetypes = markdown_ft,
  },
}
