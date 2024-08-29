return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local parsers = require("nvim-treesitter.parsers")

      vim.list_extend(opts.ensure_installed, {
        "proto",
        "java",
        "kotlin",
        "hocon",
        "php",
        "ruby",
        "dart",
      })

      local parser_configs = parsers.get_parser_configs()

      local github_mirror = "https://github.com/"
      for _, config in pairs(parser_configs) do
        config.install_info.url = config.install_info.url:gsub("https://github.com/", github_mirror)
      end

      vim.treesitter.language.register("terraform", "terraform-vars")
      return vim.tbl_deep_extend("force", opts, {
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "gnn", -- set to `false` to disable one of the mappings
            node_incremental = "grn",
            scope_incremental = "grc",
            node_decremental = "<bs>",
          },
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
