--[[ plugins/nvim-autopairs.lua ]]

require("nvim-autopairs").setup({
  disable_filetype = { "TelescopePrompt" },
  map_cr = true,
  fast_wrap = {
    map = "<M-e>",
    chars = { "{", "[", "(", '"', "'" },
    pattern = [=[[%'%"%)%>%]%)%}%,]]=],
    end_key = "$",
    keys = "qwertyuiopzxcvbnmasdfghjkl",
    check_comma = true,
    highlight = "Search",
    highlight_grey="Comment"
  },
})
