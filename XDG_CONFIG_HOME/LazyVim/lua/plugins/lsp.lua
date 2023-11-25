return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {
          -- enabled = false,
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
      },
    },
  },
}
