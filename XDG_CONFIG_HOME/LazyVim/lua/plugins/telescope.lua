local actions = require("telescope.actions")

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      -- project management
      {
        "ahmedkhalf/project.nvim",
        opts = {
          manual_mode = false,
          exclude_dirs = { "~/.cargo/*", "*/node_modules/*" },
          scope_chdir = "tab",
        },
      },
    },
    keys = {
      { "<c-p>", LazyVim.pick("files"), desc = "Find Files (root dir)" },
      { "<leader>fT", LazyVim.pick("filetypes"), desc = "Filetypes" },
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
