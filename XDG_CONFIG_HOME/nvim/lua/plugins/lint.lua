--[[ plugins/lint.lua ]]

local autocmd = vim.api.nvim_create_autocmd

local lint = require("lint")

lint.linters_by_ft = {
  markdown = {"vale",},
  yaml = {"yamllint",},
}

autocmd({"BufWritePost"}, {
  buffer = 0,
  callback = function()
    lint.try_lint()
  end
})
