local actions = require("telescope.actions")

return {
  {
    "ibhagwan/fzf-lua",
    keys = {
      { "<c-p>", LazyVim.pick("auto"), desc = "Find Files (root dir)" },
      { "<leader>fT", LazyVim.pick("filetypes"), desc = "Filetypes" },
      { "<leader>sy", "<cmd>Telescope yaml_schema<cr>", desc = "Yaml schema" },
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
  -- project management
  {
    "ahmedkhalf/project.nvim",
    opts = {
      manual_mode = false,
      exclude_dirs = { "~/.cargo/*", "*/node_modules/*" },
      scope_chdir = "tab",
    },
    event = "VeryLazy",
    config = function(_, opts)
      require("project_nvim").setup(opts)
      LazyVim.on_load("telescope.nvim", function()
        require("telescope").load_extension("projects")
      end)
    end,
  },
}
