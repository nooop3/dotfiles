--[[ autpcmds.lua ]]

local o = vim.o
local g = vim.g
local fn = vim.fn
local cmd = vim.cmd
-- local opt = vim.opt
local opt_local = vim.opt_local
local map = vim.keymap.set
local has = vim.fn.has
local system = vim.fn.system
local trim = vim.fn.trim
local autocmd = vim.api.nvim_create_autocmd
local nvim_buf_get_option = vim.api.nvim_buf_get_option

-- local augroup = vim.api.nvim_create_augroup
local function augroup(name)
  return vim.api.nvim_create_augroup("personal_" .. name, { clear = true })
end

-- https://github.com/vim/vim/blob/master/runtime/defaults.vim#L101
-- When editing a file, always jump to the last known cursor position.
-- Don't do it when the position is invalid, when inside an event handler
-- (happens when dropping a file on gvim) and for a commit message (it's
-- likely a different one than last time).
local vim_startup = augroup("vim_startup")
autocmd({ "BufReadPost" }, {
  group = vim_startup,
  pattern = { "*" },
  callback = function()
    local quote_mark_line = fn.line("'" .. '"')
    local last_line = fn.line("$")
    if quote_mark_line >= 1 and quote_mark_line <= last_line and o.ft ~= "commit" then
      cmd('normal! g`"')
    end
  end,
})

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

-- Auto change the tabstop
local file_type_tab_stop = augroup("file_type_tab_stop")
autocmd({ "FileType" }, {
  group = file_type_tab_stop,
  pattern = {
    "markdown",
    "sql",
  },
  callback = function()
    opt_local.expandtab = true
    opt_local.tabstop = 4
    opt_local.softtabstop = 4
    opt_local.shiftwidth = 4
  end,
})
autocmd({ "FileType" }, {
  group = file_type_tab_stop,
  pattern = {
    "javascript",
    "typescript",
    "javascriptreact",
    "typescriptreact",
    "json",
    "yaml",
    "html",
    "css",
    "lua",
    "proto",
    "sh",
    "xml",
    "sbt",
    "hocon",
  },
  callback = function()
    opt_local.expandtab = true
    opt_local.tabstop = 2
    opt_local.softtabstop = 2
    opt_local.shiftwidth = 2
  end,
})

local hocon_group = augroup("hocon_group")
vim.api.nvim_create_autocmd(
  { "BufNewFile", "BufRead" },
  { group = hocon_group, pattern = "*/resources/*.conf", command = "set ft=hocon" }
)

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
  -- pattern = { "*.py", "*.pyw", "*.c", "*h", "*.coffee", "*.md" },
  pattern = {
    "python",
    "c",
    "cpp",
    -- "coffee",
    "markdown",
    "typescript",
    -- "javascript",
    "sql",
    "proto",
  },
  callback = function()
    if not o.binary and o.filetype ~= "diff" and nvim_buf_get_option(0, "modifiable") then
      local current_view = fn.winsaveview()
      cmd([[keeppatterns %s/\s\+$//e]])
      fn.winrestview(current_view)
    end
  end,
})

-- autocmd BufWritePre *.tf lua vim.lsp.buf.formatting_sync()
-- local terraform_format = augroup("terraform_format", { clear = true })
-- autocmd({"BufWritePre"}, {
--   group = terraform_format,
--   pattern = { "*.tf" },
--   callback = function()
--     return vim.lsp.buf.formatting_sync()
--   end
-- })

g.input_toggle = 0
local fcitx2en = function()
  local input_status = trim(system("fcitx5-remote"))
  if input_status == "2" then
    g.input_toggle = 1
    system("fcitx5-remote -c")
  end
end
local fcitx2zh = function()
  local input_status = trim(system("fcitx5-remote"))
  if input_status ~= "2" and g.input_toggle == 1 then
    system("fcitx5-remote -o")
    g.input_toggle = 0
  end
end

if has("Mac") == 0 then
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

-- copy from LazyVim.config.autocmds
-- Check if we need to reload the file when it changed
vim.api.nvim_create_autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime"),
  command = "checktime",
})

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup("highlight_yank"),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- resize splits if window got resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
  group = augroup("resize_splits"),
  callback = function()
    vim.cmd("tabdo wincmd =")
  end,
})

-- go to last loc when opening a buffer
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup("last_loc"),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("close_with_q"),
  pattern = {
    "PlenaryTestPopup",
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
})

-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("wrap_spell"),
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  group = augroup("auto_create_dir"),
  callback = function(event)
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
})
