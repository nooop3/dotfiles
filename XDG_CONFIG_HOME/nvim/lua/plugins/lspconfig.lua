--[[ plugins/lspconfig.lua ]]

local nvim_lsp = require("lspconfig")
local util = require("lspconfig").util

-- Add additional capabilities supported by nvim-cmp
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require("cmp_nvim_lsp").update_capabilities(capabilities)

local opts = { noremap=true, silent=true }

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  -- local function buf_set_option(...)
  --   vim.api.nvim_buf_set_option(bufnr, ...)
  -- end

  -- Enable completion triggered by <c-x><c-o>
  -- buf_set_option("omnifunc", "v:lua.vim.lsp.omnifunc")

  local function buf_set_keymap(...)
    vim.api.nvim_buf_set_keymap(bufnr, ...)
  end

  -- Mappings.
  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
  -- buf_set_keymap("n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
  -- buf_set_keymap("n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
  -- buf_set_keymap("n", "<C-k>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  buf_set_keymap("n", "<localleader>wa", "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<localleader>wr", "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>", opts)
  buf_set_keymap("n", "<localleader>wl", "<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>", opts)
  buf_set_keymap("n", "<localleader>D", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
  -- buf_set_keymap("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- buf_set_keymap("n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  buf_set_keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
  buf_set_keymap("n", "<leader>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- buf_set_keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
  -- buf_set_keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
  buf_set_keymap("n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
  buf_set_keymap("n", "<leader>fa", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
end

-- Setup rust_analyzer via rust-tools.nvim
require("rust-tools").setup({
  server = {
    on_attach = on_attach,
    capabilities = capabilities,
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
  -- brew install rust-analyzer
  -- "rust_analyzer",
  -- npm install -g typescript typescript-language-server
  "tsserver",
  "gopls",
  -- brew install lua-language-server
  "sumneko_lua",
  -- brew install tflint
  "tflint",
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
          globals = {'vim'},
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
  if (lsp == "tflint") then
    -- root_pattern(".terraform", ".git", ".tflint.hcl")
    configs.root_dir = util.root_pattern(".git", ".tflint.hcl")
  end
  nvim_lsp[lsp].setup(configs)
end

-- npm install -g diagnostic-languageserver
-- npm i -g eslint_d prettier
nvim_lsp.diagnosticls.setup({
  on_attach = on_attach,
  filetypes = { "javascript", "json", "typescript", "markdown" },
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
