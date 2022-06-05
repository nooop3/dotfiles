--[[ plugins/nvim-comment.lua ]]

local comment = require('nvim_comment')

comment.setup({
  -- Linters prefer comment and line to have a space in between markers
  marker_padding = true,
  -- should comment out empty or whitespace only lines
  comment_empty = false,
  -- trim empty comment whitespace
  comment_empty_trim_whitespace = true,
  -- Should key mappings be created
  create_mappings = true,
  -- Normal mode mapping left hand side
  line_mapping = "<leader>c<space>",
  -- Visual/Operator mapping left hand side
  operator_mapping = "<leader>cm",
  -- text object mapping, comment chunk,,
  comment_chunk_text_object = "ic",
  -- Hook function to call before commenting takes place
  hook = nil
})
