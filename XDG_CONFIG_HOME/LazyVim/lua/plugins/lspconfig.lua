return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        yamlls = {
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = {
              customTags = { "!Ref", "!ImportValue", "!reference sequence" },
              format = {
                printWidth = 100000,
              },
            },
          },
        },
      },
      setup = {
        terraformls = function()
          -- workaround for terraform-ls sending invalid semantic tokens
          -- https://github.com/hashicorp/terraform-ls/issues/2094
          Snacks.util.lsp.on({ name = "terraformls" }, function(_, client)
            client.server_capabilities.semanticTokensProvider = nil
          end)
          -- end workaround
        end,
      },
    },
  },
}
