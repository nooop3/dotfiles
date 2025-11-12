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
            },
          },
        },
      },
    },
  },
}
