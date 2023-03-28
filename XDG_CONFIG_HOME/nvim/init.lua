-- inspired by LazyVim https://www.lazyvim.org/
-- nvim --headless "+Lazy! sync" +qa

require("options")
require("lazy-config")

if vim.fn.argc(-1) == 0 then
  -- autocmds and keymaps can wait to load
  vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("LazyVim", { clear = true }),
    pattern = "VeryLazy",
    callback = function()
      require("autocmds")
      require("keymaps")
    end,
  })
else
  -- load them now so they affect the opened buffers
  require("autocmds")
  require("keymaps")
end
