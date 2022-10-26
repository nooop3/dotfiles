--[[ variables.lua ]]

local g = vim.g

-- Colortheme gruvbox material
g.gruvbox_material_background = "hard"
g.gruvbox_material_better_performance = 1
g.gruvbox_material_enable_bold = 1

-- Disabling conceal for JSON and Markdown without disabling indentLine plugin
-- g.indentLine_setConceal = 0
-- g.vim_json_conceal = 0
-- g.vim_json_syntax_conceal = 0
g.markdown_syntax_conceal = 0
g.indentLine_fileTypeExclude = { "json", "markdown" }
