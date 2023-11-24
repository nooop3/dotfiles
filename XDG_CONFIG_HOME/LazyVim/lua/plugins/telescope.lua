local actions = require("telescope.actions")
local Util = require("lazyvim.util")

return {
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      { "<c-p>", Util.telescope("files"), desc = "Find Files (root dir)" },
      { "<leader>fT", Util.telescope("filetypes"), desc = "Filetypes" },
    },
    opts = {
      defaults = {
        mappings = {
          n = {
            ["<C-c>"] = actions.close,
            ["<C-f>"] = actions.preview_scrolling_down,
            ["<C-b>"] = actions.preview_scrolling_up,
          },
          i = {
            ["<c-t>"] = actions.select_tab,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-k>"] = actions.move_selection_previous,
          },
        },
      },
    },
  },
}
