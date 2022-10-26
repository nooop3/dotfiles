--[[ plugins/project.lua ]]

-- import project_nvim plugin safely
local status, project = pcall(require, "project_nvim")
if not status then
  return
end

project.setup({
  -- Show hidden files in telescope
  show_hidden = true,
  scope_chdir = "tab"
})
