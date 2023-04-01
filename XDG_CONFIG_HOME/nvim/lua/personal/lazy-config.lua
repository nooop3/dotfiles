local fn = vim.fn

-- lazy settings
local install_path = fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(install_path) then
  fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    -- "https://hub.fgit.ml/folke/lazy.nvim.git",
    -- "https://hub.fgit.gq/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    install_path,
  })
  return true
end
vim.opt.rtp:prepend(vim.env.LAZY or install_path)

require("lazy").setup({
  spec = {
    { import = "personal.plugins" },
    { import = "personal.plugins.lsp.lspsaga" },
    { import = "personal.plugins.lang.lua" },
    { import = "personal.plugins.lang.typescript" },
    { import = "personal.plugins.lang.shell" },
    { import = "personal.plugins.lang.json" },
    { import = "personal.plugins.lang.sql" },
    { import = "personal.plugins.lang.proto" },
    { import = "personal.plugins.lang.yaml" },
    { import = "personal.plugins.lang.makrdown" },
    { import = "personal.plugins.lang.python" },
    { import = "personal.plugins.lang.rust" },
    { import = "personal.plugins.lang.golang" },
    { import = "personal.plugins.lang.java" },
    { import = "personal.plugins.lang.clang" },
    { import = "personal.plugins.lang.hcl" },
  },
  defaults = {
    -- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
    -- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
    lazy = false,
    -- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
    -- have outdated releases, which may break your Neovim install.
    version = false, -- always use the latest git commit
    -- version = "*", -- try installing the latest stable version for plugins that support semver
  },
  -- lockfile = fn.stdpath("data") .. "/lazy/lazy-lock.json",
  concurrency = 4,
  git = {
    timeout = 60,
    -- url_format = "https://github.com/%s.git",
    -- url_format = "https://hub.fgit.ml/%s.git",
  },
  install = { colorscheme = { "gruvbox-material" } },
  change_detection = { enabled = false },
  performance = {
    rtp = {
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        -- "matchit",
        -- "matchparen",
        -- "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
