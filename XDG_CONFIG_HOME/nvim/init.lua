-- inspired by LazyVim https://www.lazyvim.org/
-- nvim --headless "+Lazy! sync" +qa

require("personal.options")
require("personal.lazy")

-- autocmds can be loaded lazily when not opening a file
local lazy_autocmds = vim.fn.argc(-1) == 0
if not lazy_autocmds then
  require("personal.autocmds")
end
local group = vim.api.nvim_create_augroup("LazyVim", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = "VeryLazy",
  callback = function()
    if lazy_autocmds then
      require("personal.autocmds")
    end
    require("personal.keymaps")
  end,
})
