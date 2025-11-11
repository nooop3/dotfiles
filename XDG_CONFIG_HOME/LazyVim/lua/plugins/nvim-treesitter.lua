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
        "just",
      })

      -- jinjia

      ---@diagnostic disable-next-line: inject-field
      -- parser_config.jinja = {
      --   install_info = {
      --     url = "https://github.com/cathaysia/tree-sitter-jinja",
      --     files = { "tree-sitter-jinja/src/parser.c" },
      --   },
      --   filetype = "jinja",
      -- }

      -- ---@diagnostic disable-next-line: inject-field
      -- parser_config.jinja_inline = {
      --   install_info = {
      --     url = "https://github.com/cathaysia/tree-sitter-jinja",
      --     files = { "tree-sitter-jinja_inline/src/parser.c" },
      --   },
      -- }

      -- vim.list_extend(opts.ensure_installed, { "jinja", "jinja_inline" })

      vim.treesitter.language.register("terraform", "terraform-vars")
      return vim.tbl_deep_extend("force", opts, {
        indent = {
          enable = true,
        },
      })
    end,
  },
}
