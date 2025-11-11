return {
  {
    "nvim-mini/mini.surround",
    enabled = false,
    opts = {
      mappings = {
        add = "csa",
        delete = "csd",
        find = "csf",
        find_left = "csF",
        highlight = "csh",
        replace = "csr",
        update_n_lines = "csn",
      },
    },
  },
  { "tpope/vim-surround" },
}
