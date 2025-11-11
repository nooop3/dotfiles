return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "proto",
        "java",
        "kotlin",
        "hocon",
        "php",
        "dart",
        "just",
      })
      vim.treesitter.language.register("terraform", "terraform-vars")
    end,
  },
}
