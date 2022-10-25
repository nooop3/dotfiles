--[[ plugins/telescope-tabs.lua ]]

local map = vim.keymap.set

local tabs = require("telescope-tabs")

tabs.setup({
  -- entry_formatter = function(tab_id, buffer_ids, file_names, file_paths)
  entry_formatter = function(tab_id, _, file_names, _)
    local entry_string = table.concat(file_names, ', ')
    return string.format('%d: %s', tab_id, entry_string)
  end,
  -- entry_ordinal = function(tab_id, buffer_ids, file_names, file_paths)
  entry_ordinal = function(_, _, file_names, _)
    return table.concat(file_names, ' ')
  end,
  show_preview = true,
  close_tab_shortcut_i = '<C-d>', -- if you're in insert mode
  close_tab_shortcut_n = 'D', -- if you're in normal mode
})

map("n", "<leader>fa", tabs.list_tabs, { silent = true })
