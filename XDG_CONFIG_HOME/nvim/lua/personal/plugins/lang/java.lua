return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "java", "kotlin", "scala", "hocon" })
      end
    end,
  },
  {
    "scalameta/nvim-metals",
    ft = { "scala", "sbt", "java" },
    config = function()
      local metals_config = require("metals").bare_config()
      metals_config.settings = {
        showImplicitArguments = true,
        excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
      }

      metals_config.capabilities = require("cmp_nvim_lsp").default_capabilities()

      require("metals").initialize_or_attach(metals_config)
    end,
  },
}
