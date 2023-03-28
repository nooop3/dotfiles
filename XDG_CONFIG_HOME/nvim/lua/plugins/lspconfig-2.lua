if true then
  return {}
end
return {
  -- Collection of configurations for the built-in LSP client
  {
    "neovim/nvim-lspconfig",
    enabled = false,
    config = function()
      -- import lspconfig plugin safely
      local lspconfig_status, lspconfig = pcall(require, "lspconfig")
      if not lspconfig_status then
        return
      end

      -- import cmp-nvim-lsp plugin safely
      local cmp_nvim_lsp_status, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
      if not cmp_nvim_lsp_status then
        return
      end

      local util = lspconfig.util

      -- Add additional capabilities supported by nvim-cmp
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true
      capabilities = cmp_nvim_lsp.default_capabilities(capabilities)

      local opts = { noremap = true, silent = true }
      -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
      -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
      vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

      -- Use an on_attach function to only map the following keys
      -- after the language server attaches to the current buffer
      local on_attach = function(_, bufnr)
        --[[ local config = client.config
        for _, dir in pairs({ config.root_dir, config.cmd_cwd }) do
        if dir and vim.fn.isdirectory(dir .. "/.git") == 1 then
        vim.api.nvim_set_current_dir(dir)
        vim.api.nvim_tabpage_set_var(0, "root_dir", dir)
        -- vim.cmd("tcd " .. dir)
        -- vim.cmd("lcd " .. dir)
        break
        end
        end ]]

        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        -- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
        -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set("n", "<localleader>wa", vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set("n", "<localleader>wr", vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set("n", "<localleader>wl", function()
          print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set("n", "<localleader>D", vim.lsp.buf.type_definition, bufopts)
        -- vim.keymap.set('n', '<localleader>rn', vim.lsp.buf.rename, bufopts)
        -- vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
        -- vim.keymap.set("n", "<leader>fv", function()
        -- 	vim.lsp.buf.format({ async = true })
        -- end, bufopts)
      end

      -- Setup rust_analyzer via rust-tools.nvim
      -- brew install rust-analyzer
      -- pacman -S rust-analyzer
      -- rustup update
      -- rustup component add clippy
      require("rust-tools").setup({
        server = {
          on_attach = on_attach,
          capabilities = capabilities,
          -- root_dir = util.root_pattern(".git"),
          settings = {
            ["rust-analyzer"] = {
              cargo = {
                -- features = { "all" },
              },
              checkOnSave = {
                allTargets = false,
                -- default: `cargo check`
                command = "clippy",
              },
              imports = {
                granularity = {
                  enforce = true,
                },
                prefix = "crate",
              },
              inlayHints = {
                lifetimeElisionHints = {
                  enable = true,
                  useParameterNames = true,
                },
              },
            },
          },
        },
      })

      -- Use a loop to conveniently call "setup" on multiple servers and
      -- map buffer local keybindings when the language server attaches
      local servers = {}
      for _, lsp in pairs(servers) do
        local configs = {
          on_attach = on_attach,
          capabilities = capabilities,
        }

        lspconfig[lsp].setup(configs)
      end

      -- npm install -g diagnostic-languageserver
      -- npm i -g eslint_d prettier
      lspconfig.diagnosticls.setup({
        on_attach = on_attach,
        filetypes = { "javascript", "typescript", "markdown" },
        root_dir = function(fname)
          return util.root_pattern("tsconfig.json")(fname) or util.root_pattern(".eslintrc.json")(fname)
        end,
        init_options = {
          linters = {
            eslint = {
              command = "eslint_d",
              rootPatterns = { ".git" },
              debounce = 100,
              args = { "--stdin", "--stdin-filename", "%filepath", "--format", "json" },
              sourceName = "eslint_d",
              parseJson = {
                errorsRoot = "[0].messages",
                line = "line",
                column = "column",
                endLine = "endLine",
                endColumn = "endColumn",
                message = "[eslint] ${message} [${ruleId}]",
                security = "severity",
              },
              securities = {
                [2] = "error",
                [1] = "warning",
              },
            },
          },
          filetypes = {
            javascript = "eslint",
            typescript = "eslint",
          },
          formatters = {
            eslint_d = {
              command = "eslint_d",
              args = { "--stdin", "--stdin-filename", "%filename", "--fix-to-stdout" },
              rootPatterns = { ".git" },
            },
            prettier = {
              command = "prettier",
              args = { "--stdin-filepath", "%filename" },
            },
          },
          formatFiletypes = {
            typescript = "eslint_d",
            javascript = "eslint_d",
            json = "prettier",
            typescriptreact = "eslint_d",
            javascriptreact = "eslint_d",
            markdown = "prettier",
            css = "prettier",
            scss = "prettier",
            less = "prettier",
          },
        },
      })
    end,
  },
}
