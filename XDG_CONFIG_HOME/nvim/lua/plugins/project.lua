--[[ plugins/project.lua ]]

local project = require("project_nvim")

project.setup({
  -- Show hidden files in telescope
  show_hidden = true,
  scope_chdir = "tab"
})
