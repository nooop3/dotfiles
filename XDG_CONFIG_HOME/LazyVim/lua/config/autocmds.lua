-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

local map = vim.keymap.set
local opt_local = vim.opt_local
local autocmd = vim.api.nvim_create_autocmd

local function augroup(name)
  return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end

-- Markdown add the checkbox
local markdown_checkbox = augroup("markdown_checkbox")
autocmd({ "FileType" }, {
  group = markdown_checkbox,
  pattern = { "markdown" },
  callback = function()
    map(
      { "n", "v" },
      "<Leader>x<space>",
      ":s/^\\s*\\(- \\\\|\\* \\)\\?\\zs\\(\\[[^\\]]*\\] \\)\\?\\ze./[ ] /<CR>0t]<CR>",
      {
        buffer = true,
        silent = true,
        desc = "Add checkbox",
      }
    )
    map({ "n", "v" }, "<Leader>xx", ":s/^\\s*\\(- \\\\|\\* \\)\\?\\zs\\(\\[[^\\]]*\\] \\)\\?\\ze./[x] /<CR>0t]<CR>", {
      buffer = true,
      silent = true,
      desc = "Add checkbox",
    })
  end,
})

local hocon_group = augroup("hocon_group")
autocmd({ "BufNewFile", "BufRead" }, {
  group = hocon_group,
  pattern = "*/resources/*.conf",
  command = "set ft=hocon",
})

-- Custom file type changes
local custom_file_type_changes = augroup("custom_file_type_changes")
autocmd({ "BufNewFile", "BufRead" }, {
  group = custom_file_type_changes,
  pattern = { "crontab*" },
  callback = function()
    opt_local.filetype = "crontab"
  end,
})
autocmd({ "BufNewFile", "BufRead" }, {
  group = custom_file_type_changes,
  pattern = { "*.nomad" },
  callback = function()
    opt_local.filetype = "hcl"
  end,
})
autocmd({ "FileType" }, {
  group = custom_file_type_changes,
  pattern = { "json" },
  callback = function()
    opt_local.filetype = "jsonc"
  end,
})
autocmd({ "BufNewFile", "BufRead" }, {
  group = custom_file_type_changes,
  pattern = { "Podfile", "*.podspec", "*/fastlane/*file" },
  callback = function()
    opt_local.filetype = "ruby"
  end,
})

vim.g.input_toggle = 0
local fcitx2en = function()
  local input_status = vim.fn.trim(vim.fn.system("fcitx5-remote"))
  if input_status == "2" then
    vim.g.input_toggle = 1
    vim.fn.system("fcitx5-remote -c")
  end
end
local fcitx2zh = function()
  local input_status = vim.fn.trim(vim.fn.system("fcitx5-remote"))
  if input_status ~= "2" and vim.g.input_toggle == 1 then
    vim.fn.system("fcitx5-remote -o")
    vim.g.input_toggle = 0
  end
end

if vim.fn.has("Mac") == 0 then
  -- opt.timeoutlen = 150
  local auto_fcitx = augroup("auto_fcitx")
  autocmd({ "InsertLeave" }, {
    group = auto_fcitx,
    pattern = { "*" },
    callback = fcitx2en,
  })
  autocmd({ "InsertEnter" }, {
    group = auto_fcitx,
    pattern = { "*" },
    callback = fcitx2zh,
  })
end
