return {
  -- A file explorer tree for neovim written in lua
  "nvim-tree/nvim-tree.lua",
  version = "nightly", -- optional, updated every week. (see issue #1193)
  keys = {
    -- Toggle nvim-tree
    { "<C-n>", [[:NvimTreeToggle<CR>]], noremap = true, silent = true, desc = "nvim-tree toggle" },
  },
  opts = {
    open_on_tab = false,
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
      enable = true,
      update_root = true,
    },
    view = {
      mappings = {
        list = {
          { key = "s", action = "" },
        },
      },
    },
  },
}
