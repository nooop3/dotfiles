--[[ plugins/lspconfig.lua ]]
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
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, opts)
-- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)
-- vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opts)
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, opts)

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- Enable completion triggered by <c-x><c-o>
  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  local bufopts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
  -- vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
  -- vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
  vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
  -- vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
  vim.keymap.set('n', '<localleader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
  vim.keymap.set('n', '<localleader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
  vim.keymap.set('n', '<localleader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts)
  vim.keymap.set('n', '<localleader>D', vim.lsp.buf.type_definition, bufopts)
  -- vim.keymap.set('n', '<localleader>rn', vim.lsp.buf.rename, bufopts)
  -- vim.keymap.set('n', '<localleader>ca', vim.lsp.buf.code_action, bufopts)
  vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
  vim.keymap.set('n', '<leader>fv', function() vim.lsp.buf.format { async = true } end, bufopts)
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
          prefix = "crate"
        },
        inlayHints = {
          lifetimeElisionHints = {
            enable = true,
            useParameterNames = true,
          }
        }
      }
    }
  }
})

-- Use a loop to conveniently call "setup" on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = {
  -- brew install llvm
  "clangd",
  -- pip3 install "python-lsp-server[all]"
  -- "pylsp",
  -- npm install -g pyright
  "pyright",
  -- npm i -g bash-language-server
  "bashls",
  -- npm install -g typescript typescript-language-server
  "tsserver",
  "gopls",
  -- sudo pacman -S lua-language-server
  -- brew install lua-language-server
  "sumneko_lua",
  -- curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash
  -- brew install tflint
  "tflint",
  -- brew install hashicorp/tap/terraform-ls
  -- "terraformls",
  -- npm i -g vscode-langservers-extracted
  "jsonls",
}
for _, lsp in pairs(servers) do
  local configs = {
    on_attach = on_attach,
    capabilities = capabilities,
  }

  -- Golang
  if (lsp == "gopls") then
    configs.settings = {
      gopls = {
        experimentalPostfixCompletions = true,
        analyses = {
          unusedparams = true,
          shadow = true,
        },
        staticcheck = true,
      },
    }
    configs.init_options = {
      usePlaceholders = true,
    }
  end

  -- lua
  if (lsp == "sumneko_lua") then
    configs.settings = {
      Lua = {
        runtime = {
          -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
          version = 'LuaJIT',
        },
        diagnostics = {
          -- Get the language server to recognize the `vim` global
          globals = { 'vim' },
        },
        workspace = {
          -- Make the server aware of Neovim runtime files
          library = vim.api.nvim_get_runtime_file("", true),
        },
        -- Do not send telemetry data containing a randomized but unique identifier
        telemetry = {
          enable = false,
        },
      },
    }
  end

  -- tflint
  if (lsp == "tflint") or (lsp == "terraformls") then
    -- root_pattern(".terraform", ".git", ".tflint.hcl")
    configs.root_dir = util.root_pattern(".git", ".tflint.hcl")
  end
  lspconfig[lsp].setup(configs)
end

-- npm install -g diagnostic-languageserver
-- npm i -g eslint_d prettier
lspconfig.diagnosticls.setup({
  on_attach = on_attach,
  filetypes = { "javascript", "typescript", "markdown" },
  root_dir = function(fname)
    return util.root_pattern("tsconfig.json")(fname) or
        util.root_pattern(".eslintrc.js")(fname);
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
          security = "severity"
        },
        securities = {
          [2] = "error",
          [1] = "warning"
        }
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
        args = { "--stdin-filepath", "%filename" }
      }
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
    }
  }
})
