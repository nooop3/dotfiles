return {
  -- A blazing fast and easy to configure neovim statusline plugin written in pure lua.
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  opts = {
    options = {
      icons_enabled = true,
      theme = "auto",
      -- theme = "gruvbox-material",
      -- theme = "dracula-nvim",
      disabled_filetypes = {
        statusline = { "packer", "NvimTree" },
        winbar = {},
      },
      ignore_focus = { "packer", "NvimTree", "lazy" },
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diagnostics" },
      lualine_c = {
        { "filename", file_status = true, path = 1 },
      },
      lualine_x = { "encoding", "fileformat", "filetype" },
      lualine_y = { "progress" },
      lualine_z = { "location" },
    },
    inactive_sections = {
      lualine_a = {},
      lualine_b = {},
      lualine_c = {
        {
          "filename",
          file_status = true,
          path = 1,
        },
      },
      lualine_x = { "location" },
      lualine_y = {},
      lualine_z = {},
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = { "nvim-tree", "quickfix", "lazy" },
  },
}
