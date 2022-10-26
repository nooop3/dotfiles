-- import cmp plugin safely
local status, _ = pcall(require, "bufferline")
if not status then
	return
end

local map = vim.keymap.set

local nvim_tree_events = require("nvim-tree.events")
local bufferline_api = require("bufferline.api")

-- Set barbar"s options
vim.g.bufferline = {
	-- Enable/disable animations
	animation = true,

	-- Enable/disable auto-hiding the tab bar when there is a single buffer
	auto_hide = false,

	-- Enable/disable current/total tabpages indicator (top right corner)
	tabpages = true,

	-- Enable/disable close button
	closable = false,

	-- Enables/disable clickable tabs
	--  - left-click: go to buffer
	--  - middle-click: delete buffer
	clickable = false,

	-- Excludes buffers from the tabline
	-- exclude_ft = {"javascript"},
	-- exclude_name = {"package.json"},

	-- Enable/disable icons
	-- if set to "numbers", will show buffer index in the tabline
	-- if set to "both", will show buffer index and icons in the tabline
	icons = "both",

	-- If set, the icon color will follow its corresponding buffer
	-- highlight group. By default, the Buffer*Icon group is linked to the
	-- Buffer* group (see Highlighting below). Otherwise, it will take its
	-- default value as defined by devicons.
	icon_custom_colors = false,

	-- Configure icons on the bufferline.
	icon_separator_active = "▎",
	icon_separator_inactive = "▎",
	icon_close_tab = "",
	icon_close_tab_modified = "●",
	icon_pinned = "車",

	-- If true, new buffers will be inserted at the start/end of the list.
	-- Default is to insert after current buffer.
	insert_at_end = false,
	insert_at_start = false,

	-- Sets the maximum padding width with which to surround each tab
	maximum_padding = 1,

	-- Sets the maximum buffer name length.
	maximum_length = 30,

	-- If set, the letters for each buffer in buffer-pick mode will be
	-- assigned based on their name. Otherwise or in case all letters are
	-- already assigned, the behavior is to assign letters in order of
	-- usability (see order below)
	semantic_letters = true,

	-- New buffer letters are assigned in this order. This order is
	-- optimal for the qwerty keyboard layout but might need adjustement
	-- for other layouts.
	letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",

	-- Sets the name of unnamed buffers. By default format is "[Buffer X]"
	-- where X is the buffer number. But only a static string is accepted here.
	no_name_title = nil,
}

-- Move to previous/next
map("n", "<leader>,", ":BufferPrevious<CR>", { silent = true })
map("n", "<leader>.", ":BufferNext<CR>", { silent = true })
-- Re-order to previous/next
map("n", "<leader><", ":BufferMovePrevious<CR>", { silent = true })
map("n", "<leader>>", ":BufferMoveNext<CR>", { silent = true })
-- Goto buffer in position...
map("n", "<leader>a1", ":BufferGoto 1<CR>", { silent = true })
map("n", "<leader>a2", ":BufferGoto 2<CR>", { silent = true })
map("n", "<leader>a3", ":BufferGoto 3<CR>", { silent = true })
map("n", "<leader>a4", ":BufferGoto 4<CR>", { silent = true })
map("n", "<leader>a5", ":BufferGoto 5<CR>", { silent = true })
map("n", "<leader>a6", ":BufferGoto 6<CR>", { silent = true })
map("n", "<leader>a7", ":BufferGoto 7<CR>", { silent = true })
map("n", "<leader>a8", ":BufferGoto 8<CR>", { silent = true })
map("n", "<leader>a9", ":BufferGoto 9<CR>", { silent = true })
map("n", "<leader>a0", ":BufferLast<CR>", { silent = true })
-- Pin/unpin buffer
map("n", "<leader>ap", ":BufferPin<CR>", { silent = true })
-- Close buffer
map("n", "<leader>ac", ":BufferClose<CR>", { silent = true })
-- Wipeout buffer
--                 :BufferWipeout<CR>
-- Close commands
--                 :BufferCloseAllButCurrent<CR>
--                 :BufferCloseAllButPinned<CR>
--                 :BufferCloseAllButCurrentOrPinned<CR>
--                 :BufferCloseBuffersLeft<CR>
--                 :BufferCloseBuffersRight<CR>
-- Magic buffer-picking mode
map("n", "<leader>p", ":BufferPick<CR>", { silent = true })
-- Sort automatically by...
map("n", "<leader>ab", ":BufferOrderByBufferNumber<CR>", { silent = true })
map("n", "<leader>ad", ":BufferOrderByDirectory<CR>", { silent = true })
map("n", "<leader>al", ":BufferOrderByLanguage<CR>", { silent = true })
map("n", "<leader>aw", ":BufferOrderByWindowNumber<CR>", { silent = true })

-- Other:
-- :BarbarEnable - enables barbar (enabled by default)
-- :BarbarDisable - very bad command, should never be used

local function get_tree_size()
	return require("nvim-tree.view").View.width
end

nvim_tree_events.subscribe("TreeOpen", function()
	bufferline_api.set_offset(get_tree_size())
end)

nvim_tree_events.subscribe("Resize", function()
	bufferline_api.set_offset(get_tree_size())
end)
