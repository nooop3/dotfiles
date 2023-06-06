return {
  "nvim-treesitter/nvim-treesitter",
  version = false,
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  opts = {
    ensure_installed = {
      "vim",
      "vimdoc",
      "regex",
      "php",
      "toml",
      "html",
      "ruby",
    },

    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- List of parsers to ignore installing (for "all")
    ignore_install = {},

    highlight = {
      enable = true,
      disable = { "sql" },
      additional_vim_regex_highlighting = false,
    },
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
      disable = {},
    },
    additional_vim_regex_highlighting = false,
  },
  config = function(_, opts)
    local parsers = require("nvim-treesitter.parsers")

    local parser_configs = parsers.get_parser_configs()

    local github_mirror = "https://hub.fgit.ml/"
    -- local github_mirror = "https://hub.fgit.gq/"
    -- local github_mirror = "https://github.com/"
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

    -- parsers.filetype_to_parsername.javascript = "tsx"
    -- parsers.filetype_to_parsername["typescript.tsx"] = "tsx"

    local configs = require("nvim-treesitter.configs")
    configs.setup(opts)
  end,
}
