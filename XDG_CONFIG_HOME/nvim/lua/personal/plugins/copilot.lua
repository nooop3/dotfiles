return {
  {
    "jcdickinson/codeium.nvim",
    enabled = true,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "hrsh7th/nvim-cmp",
    },
    config = function()
      -- vim.g.codeium_filetypes = {
      --   ["*"] = false,
      --   ["javascript"] = true,
      --   -- ["typescript"] = true,
      --   -- ["lua"] = false,
      --   -- ["rust"] = true,
      --   -- ["c"] = true,
      --   -- ["c#"] = true,
      --   -- ["c++"] = true,
      --   -- ["go"] = true,
      --   ["python"] = true,
      --   -- ["java"] = true,
      -- }
      require("codeium").setup({})
    end,
  },
  {
    "github/copilot.vim",
    enabled = false,
    opts = function()
      vim.g.copilot_no_tab_map = true
      vim.g.copilot_assume_mapped = true
      vim.g.copilot_tab_fallback = ""
      vim.g.copilot_filetypes = {
        ["*"] = false,
        -- ["javascript"] = true,
        -- ["typescript"] = true,
        -- ["lua"] = false,
        -- ["rust"] = true,
        -- ["c"] = true,
        -- ["c#"] = true,
        -- ["c++"] = true,
        -- ["go"] = true,
        -- ["python"] = true,
        -- ["java"] = true,
      }
    end,
  },
}
