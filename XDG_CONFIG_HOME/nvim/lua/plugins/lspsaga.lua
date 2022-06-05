--[[ plugins/lspsaga.lua ]]

local map = vim.keymap.set

local lspsaga = require("lspsaga")
local provider = require("lspsaga.provider")
local code_action = require("lspsaga.codeaction")
local action = require("lspsaga.action")
local hover = require("lspsaga.hover")
local signature_help = require("lspsaga.signaturehelp")
local rename = require("lspsaga.rename")
local diagnostic = require("lspsaga.diagnostic")
local floaterm = require("lspsaga.floaterm")

lspsaga.setup({
  debug = false,
  use_saga_diagnostic_sign = true,
  -- diagnostic sign
  error_sign = "",
  warn_sign = "",
  hint_sign = "",
  infor_sign = "",
  diagnostic_header_icon = "   ",
  -- code action title icon
  code_action_icon = " ",
  code_action_prompt = {
    enable = true,
    sign = true,
    sign_priority = 40,
    virtual_text = true,
  },
  finder_definition_icon = "  ",
  finder_reference_icon = "  ",
  max_preview_lines = 10,
  finder_action_keys = {
    open = "o",
    vsplit = "v",
    split = "s",
    quit = "q",
    scroll_down = "<C-f>",
    scroll_up = "<C-u>",
  },
  code_action_keys = {
    quit = "q",
    exec = "<CR>",
  },
  rename_action_keys = {
    quit = "<C-c>",
    exec = "<CR>",
  },
  definition_preview_icon = "  ",
  border_style = "round",
  rename_prompt_prefix = "➤",
  rename_output_qflist = {
    enable = false,
    auto_open_qflist = false,
  },
  server_filetype_map = {},
  diagnostic_prefix_format = "%d. ",
  diagnostic_message_format = "%m %c",
  highlight_prefix = false,
})

-- lsp provider to find the cursor word definition and reference
map("n", "<leader>gh", provider.lsp_finder, { silent = true })

-- code action
local function visual_code_action()
  -- vim.cmd(":<C-u>")
  return code_action.range_code_action()
end
map("n", "<leader>ca", code_action.code_action, { silent = true })
-- map("v", "<leader>ca", visual_code_action, { silent = true })
map("v", "<leader>ca", ":<C-u>lua require('lspsaga.codeaction').range_code_action()<CR>", { silent = true })

-- show hover doc
map("n", "K", hover.render_hover_doc, { silent = true })
-- scroll down hover doc or scroll in definition preview
map("n", "<C-f>", function() return action.smart_scroll_with_saga(1, "<C-f>") end, { silent = true })
-- scroll up hover doc
map("n", "<C-u>", function() return action.smart_scroll_with_saga(-1, "<C-u>") end, { silent = true })

-- show signature help
map("n", "<C-k>", signature_help.signature_help, { silent = true })

-- rename
map("n", "<leader>rn", rename.rename, { silent = true })

-- preview definition
-- FIXME: smart_scroll_with_saga not work
map("n", "gd", provider.preview_definition, { silent = true })

-- Show Diagnostic and Jump Diagnostics
map("n", "<leader>cd", diagnostic.show_line_diagnostics, { silent = true })
-- only show diagnostic if cursor is over the area
map("n", "<leader>cc", diagnostic.show_cursor_diagnostics, { silent = true })
-- jump diagnostic
map("n", "[d", diagnostic.navigate("prev"), { silent = true })
map("n", "]d", diagnostic.navigate("next"), { silent = true })

-- float terminal also you can pass the cli command in open_float_terminal function
map("n", "<leader>tt", floaterm.open_float_terminal, { silent = true })
map("t", "<leader>tt", floaterm.close_float_terminal, { silent = true })
