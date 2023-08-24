local lua_ls_library = vim.api.nvim_get_runtime_file("", true)
table.insert(
  lua_ls_library,
  -- fix undefined field warning
  vim.fn.stdpath("config") .. "/lua"
)

return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "lua" })
      end
    end,
  },

  -- correctly setup lspconfig
  {
    "neovim/nvim-lspconfig",
    opts = {
      -- make sure mason installs the server
      servers = {
        ---@type lspconfig.options.lua_ls
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                -- Make the server aware of Neovim runtime files
                library = lua_ls_library,
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              runtime = {
                -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = "LuaJIT",
              },
              diagnostics = {
                -- Get the language server to recognize the `vim` global
                globals = { "vim" },
              },
              -- Do not send telemetry data containing a randomized but unique identifier
              telemetry = {
                enable = false,
              },
            },
          },
        },
      },
    },
  },
  {
    "williamboman/mason.nvim",
    opts = function(_, opts)
      table.insert(opts.ensure_installed, "stylua")
    end,
  },
  {
    "jose-elias-alvarez/null-ls.nvim",
    opts = function(_, opts)
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.formatting.stylua.with({
          condition = function(utils)
            return utils.root_has_file({ "stylua.toml", ".stylua.toml" })
          end,
        }),
      })
    end,
  },
}
