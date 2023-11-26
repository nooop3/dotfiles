-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

local fn = vim.fn
local cmd = vim.cmd
local map = vim.keymap.set
local opt_local = vim.opt_local
local autocmd = vim.api.nvim_create_autocmd
local nvim_buf_get_option = vim.api.nvim_buf_get_option

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
  pattern = { "Podfile", "*.podspec" },
  callback = function()
    opt_local.filetype = "ruby"
  end,
})
autocmd({ "BufNewFile", "BufRead" }, {
  group = custom_file_type_changes,
  pattern = { "*" },
  callback = function()
    if vim.fn.expand("%:e"):match("ya?ml") and vim.fn.search("{{.\\+}}", "nw") ~= 0 then
      opt_local.filetype = "gotmpl"
    end
  end,
})

-- Delete trailing white space on save, useful for Python and CoffeeScript ;)
local delete_trailing_white_space = augroup("delete_trailing_white_space")
autocmd({ "FileType" }, {
  group = delete_trailing_white_space,
  pattern = {
    "python",
    "c",
    "cpp",
    "markdown",
    "typescript",
    -- "javascript",
    "sql",
    "proto",
  },
  callback = function()
    if not vim.bo.binary and vim.bo.filetype ~= "diff" and nvim_buf_get_option(0, "modifiable") then
      local current_view = fn.winsaveview()
      cmd([[keeppatterns %s/\s\+$//e]])
      fn.winrestview(current_view)
    end
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

-- local file_type_comment_strings = augroup_lazy("file_type_comment_strings")
-- -- vim.print(file_type_comment_strings)
-- vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
--   group = file_type_comment_strings,
--   pattern = { "*" },
--   callback = function()
--     local filetype_comments = {
--       proto = "//%s",
--     }
--
--     local ft = vim.bo.filetype
--     vim.print(ft)
--     if file_type_comment_strings[ft] then
--       opt_local.commentstring = filetype_comments[ft]
--     end
--   end,
-- })
