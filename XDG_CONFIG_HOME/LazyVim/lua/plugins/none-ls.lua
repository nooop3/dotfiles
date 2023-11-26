local Util = require("lazyvim.util")

local function find_config_file(cwd)
  -- set cwd default to home dir
  cwd = cwd or vim.fn.expand("$HOME")
  while cwd ~= "/" do
    local file_names = { ".protolint", "protolint" }
    local file_extensions = { ".yaml", ".yml" }

    for _, name in ipairs(file_names) do
      for _, ext in ipairs(file_extensions) do
        local config_file = cwd .. "/" .. name .. ext
        if vim.fn.filereadable(config_file) == 1 then
          return config_file
        end
      end
    end

    cwd = vim.fn.fnamemodify(cwd, ":h")
  end

  local home_config_file_path = vim.fn.expand("~/.config/protolint/config.yaml")
  if vim.fn.filereadable(home_config_file_path) == 1 then
    return home_config_file_path
  end

  return nil
end

return {
  {
    "nvimtools/none-ls.nvim",
    opts = function(_, opts)
      -- opts.debug = true
      local nls = require("null-ls")
      vim.list_extend(opts.sources, {
        nls.builtins.diagnostics.protolint.with({
          -- diagnostics_format = "[#{c}] #{m} (#{s})",
          extra_args = function()
            local cwd = Util.root.get()
            local config_file_path = find_config_file(cwd)

            return config_file_path and { "--config_path", config_file_path } or {}
          end,
        }),
        nls.builtins.formatting.protolint.with({
          -- diagnostics_format = "[#{c}] #{m} (#{s})",
          extra_args = function()
            local cwd = Util.root.get()
            local config_file_path = find_config_file(cwd)

            local args = config_file_path
                and {
                  "--config_path",
                  config_file_path,
                }
              or {}

            return vim.list_extend(args, {
              "-auto_disable",
              -- "this",
              "next",
            })
          end,
        }),
      })
    end,
  },
}
