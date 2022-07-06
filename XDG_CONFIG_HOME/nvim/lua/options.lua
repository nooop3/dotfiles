--[[ options.lua ]]

local api = vim.api
local opt = vim.opt
local has = vim.fn.has
local cmd = vim.api.nvim_command

-- [[ Theme ]]
opt.syntax = "ON"
opt.background = "dark"
if has("termguicolors") == 1 then
  opt.termguicolors = true
end
-- cmd:  Set the colorscheme
-- cmd("colorscheme dracula")
if #api.nvim_get_runtime_file("colors/gruvbox-material.vim", true) ~= 0 then
  cmd("colorscheme gruvbox-material")
end

-- [[ Filetypes ]]
opt.encoding = "utf8"
opt.fileencodings = "utf8"
opt.fileformat = "unix"
opt.fileformats = "unix"
opt.fixendofline = false

-- [[ Search ]]
-- opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true
opt.hlsearch = true

-- [[ Whitespace ]]
opt.autoindent = true
opt.smartindent = true
opt.smarttab = true
opt.expandtab = true
opt.tabstop = 2
opt.softtabstop = 2
opt.shiftwidth = 2

-- [[ Splits ]]
opt.splitright = true
opt.splitbelow = true

-- [[ Context ]]
-- opt.colorcolumn = "80"
opt.number = true
-- opt.relativenumber = true
opt.scrolloff = 4
opt.laststatus = 2
opt.signcolumn = "number"
opt.listchars = {eol = "↲", tab = "▸ ", trail = "·"}

opt.textwidth= 79
opt.cmdheight = 2
opt.updatetime = 300

opt.cursorline = true
opt.cursorcolumn = true
opt.showmatch = true
opt.showmode = true
opt.autoread = true
opt.autowrite = true
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.wrap = true
opt.swapfile = false
opt.linebreak = true
opt.errorbells = false
opt.visualbell = true

opt.shortmess = "atIc"
opt.foldlevel = 99
opt.foldminlines = 3
-- opt.foldmethod = "indent"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.whichwrap = "b,<,>,[,],h,l"
opt.guioptions = nil
if has('mac') then
  opt.guifont = "SauceCodePro Nerd Font"
elseif has('linux') then
  opt.guifont = "Source Code Pro"
end
-- opt.clipboard = opt.clipboard + "unnamedplus"

-- opt.completeopt = opt.completeopt - "preview"
if (vim.fn.executable("rg") == 1) then
  opt.grepprg = "rg --vimgrep"
end
