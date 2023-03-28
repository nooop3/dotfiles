-- This file is automatically loaded by plugins.config

-- LEADER
-- These keybindings need to be defined before the first /
-- is called; otherwise, it will default to "\"
vim.g.mapleader = ";"
vim.g.localleader = "\\"

-- nvim-tree
-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- netrw
-- vim.g.netrw_banner = 0
-- vim.g.netrw_liststyle = 3
-- vim.g.netrw_browse_split = 4
-- vim.g.netrw_altv = 1
-- vim.g.netrw_winsize = 25

-- Colortheme gruvbox material
vim.g.gruvbox_material_background = "hard"
vim.g.gruvbox_material_better_performance = 1
vim.g.gruvbox_material_enable_bold = 1

local opt = vim.opt

opt.autowrite = true -- Enable auto write
-- opt.clipboard = "unnamedplus" -- Sync with system clipboard
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
-- opt.expandtab = true -- Use spaces instead of tabs
opt.formatoptions = "jcroqlnt" -- tcqj
opt.grepformat = "%f:%l:%c:%m"
if vim.fn.executable("rg") == 1 then
	opt.grepprg = "rg --vimgrep"
end
opt.ignorecase = true -- Ignore case
opt.inccommand = "nosplit" -- preview incremental substitute
opt.laststatus = 0
opt.list = true -- Show some invisible characters (tabs...
opt.mouse = "a" -- Enable mouse mode
opt.number = true -- Print line number
opt.pumblend = 10 -- Popup blend
opt.pumheight = 10 -- Maximum number of entries in a popup
opt.relativenumber = false -- Relative line numbers
opt.scrolloff = 4 -- Lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize" }
opt.shiftround = true -- Round indent
-- opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true })
opt.showmode = true
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "number"
opt.smartcase = true -- Don't ignore case with capitals
opt.smartindent = true -- Insert indents automatically
opt.autoindent = true
opt.smarttab = true
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.syntax = "ON"
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = true

-- [[ Filetypes ]]
opt.encoding = "utf8"
opt.fileencodings = "utf8"
opt.fileformat = "unix"
opt.fileformats = "unix"
opt.fixendofline = false

-- [[ Search ]]
opt.incsearch = true
opt.hlsearch = true

-- [[ Context ]]
-- opt.colorcolumn = "80"
opt.backspace = "indent,eol,start"
opt.listchars = { eol = "↲", space = "⋅", tab = "▸ ", trail = "·" }

opt.textwidth = 79
opt.cmdheight = 2

opt.cursorcolumn = true
opt.showmatch = true
opt.autoread = true
opt.hidden = true
opt.backup = false
opt.writebackup = false
opt.wrap = true
opt.swapfile = false
opt.linebreak = true
opt.errorbells = false
opt.visualbell = true

opt.foldlevel = 99
opt.foldminlines = 3
-- opt.foldmethod = "indent"
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.whichwrap = "b,<,>,[,],h,l"
opt.guioptions = nil
-- opt.iskeyword = opt.iskeyword + "-"

if vim.fn.has("nvim-0.9.0") == 1 then
	opt.splitkeep = "screen"
	opt.shortmess:append({ C = true })
end

-- Fix markdown indentation settings
vim.g.markdown_recommended_style = 0
