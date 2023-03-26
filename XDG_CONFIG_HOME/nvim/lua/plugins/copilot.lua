
return {
  {
    "github/copilot.vim",
    enabled = false,
    opts = function ()
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
    end
  }
}
