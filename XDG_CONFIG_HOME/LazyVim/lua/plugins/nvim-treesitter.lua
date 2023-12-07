return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      local parsers = require("nvim-treesitter.parsers")

      vim.list_extend(opts.ensure_installed, {
        "proto",
        "java",
        "kotlin",
        "scala",
        "hocon",
        "php",
        "ruby",
        "dart",
      })

      local parser_configs = parsers.get_parser_configs()

      local github_mirror = "https://github.com/"
      ---@diagnostic disable-next-line: inject-field
      parser_configs.gotmpl = {
        install_info = {
          url = "https://github.com/ngalaiko/tree-sitter-go-template",
          files = { "src/parser.c" },
        },
        filetype = "gotmpl",
        used_by = { "gohtmltmpl", "gotexttmpl", "gotmpl", "yaml" },
      }
      for _, config in pairs(parser_configs) do
        config.install_info.url = config.install_info.url:gsub("https://github.com/", github_mirror)
      end

      return vim.tbl_deep_extend("force", opts, {
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<CR>",
            scope_incremental = "<CR>",
            node_incremental = "<TAB>",
            node_decremental = "<S-TAB>",
          },
        },
        indent = {
          enable = true,
        },
      })
    end,
  },
}
