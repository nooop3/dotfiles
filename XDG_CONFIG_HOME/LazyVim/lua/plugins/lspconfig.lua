local yaml_setting = {
  format = {
    enable = true,
  },
  validate = true,
  schemas = {
    kubernetes = "templates/**",
    ["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
    ["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
    ["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
    ["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
    ["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
    ["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
    ["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
    ["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
    ["https://gitlab.com/gitlab-org/gitlab/-/raw/master/app/assets/javascripts/editor/schema/ci.json"] = "*gitlab-ci*.{yml,yaml}",
    ["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] = "*api*.{yml,yaml}",
    ["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] = "*flow*.{yml,yaml}",
    ["https://raw.githubusercontent.com/docker/compose/master/compose/config/compose_spec.json"] = "{docker-,}compose*.{yml,yaml}",
  },
  schemaStore = {
    enable = false,
    url = "",
  },
  customTags = { "!Ref", "!ImportValue", "!reference sequence" },

  keyOrdering = false,
}

return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "jose-elias-alvarez/typescript.nvim",
      "someone-stole-my-name/yaml-companion.nvim",
      init = function()
        require("lazyvim.util").lsp.on_attach(function(_, buffer)
          -- stylua: ignore
          vim.keymap.set("n", "<leader>co", "TypescriptOrganizeImports", { buffer = buffer, desc = "Organize Imports" })
          vim.keymap.set("n", "<leader>cR", "TypescriptRenameFile", { desc = "Rename File", buffer = buffer })
        end)
      end,
    },
    opts = {
      inlay_hints = {
        enabled = true,
      },
      servers = {
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              runtime = {
                version = "LuaJIT",
              },
              diagnostics = {
                globals = { "vim" },
              },
              telemetry = {
                enable = false,
              },
              semantic = {
                enable = false,
              },
            },
          },
        },
        clangd = {
          -- enabled = false,
          -- disabled_filetypes = { "proto" },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
        },
        tsserver = {
          enabled = false,
          init_options = {
            hostInfo = "neovim",
            disableAutomaticTypingAcquisition = false,
            preferences = {
              quotePreference = "single",
              -- importModuleSpecifierEnding = "js",
              importModuleSpecifierEnding = "auto",
            },
            -- tsserver = {
            --   logDirectory = vim.fn.expand("~/.cache/nvim/"),
            --   logVerbosity = "verbose",
            -- },
          },
          settings = {
            javascript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            typescript = {
              inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true,
              },
            },
            diagnostics = {
              ignoredCodes = {
                -- See https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json for a full list of valid codes.
                -- Initializer provides no value for this binding element and the binding element has no default value.
                2525,
                -- Could not find a declaration file for module '{0}'. '{1}' implicitly has an 'any' type.
                7016,
                -- Parameter '{0}' implicitly has an '{1}' type, but a better type may be inferred from usage.
                7044,
                -- File is a CommonJS module; it may be converted to an ES module.
                80001,
              },
            },
            implicitProjectConfiguration = {
              checkJs = true,
              experimentalDecorators = true,
              -- implicitProjectConfiguration = "ESNext",
            },
          },
        },
        vtsls = {
          -- enabled = true,
          handlers = {
            ["textDocument/publishDiagnostics"] = function(_, result, ctx)
              if result.diagnostics == nil then
                return
              end

              -- ignore some tsserver diagnostics
              local idx = 1
              while idx <= #result.diagnostics do
                local entry = result.diagnostics[idx]

                -- local formatter = require("format-ts-errors")[entry.code]
                -- entry.message = formatter and formatter(entry.message) or entry.message

                local ignoredCodes = {
                  -- See https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json for a full list of valid codes.
                  -- Initializer provides no value for this binding element and the binding element has no default value.
                  2525,
                  -- Could not find a declaration file for module '{0}'. '{1}' implicitly has an 'any' type.
                  7016,
                  -- Parameter '{0}' implicitly has an '{1}' type, but a better type may be inferred from usage.
                  7044,
                  -- codes: https://github.com/microsoft/TypeScript/blob/main/src/compiler/diagnosticMessages.json
                  -- File is a CommonJS module; it may be converted to an ES module.
                  -- { message = "File is a CommonJS module; it may be converted to an ES module.", }
                  80001,
                }
                local shouldIgnored = false
                for _, value in ipairs(ignoredCodes) do
                  if value == entry.code then
                    shouldIgnored = true
                    break
                  end
                end
                if shouldIgnored then
                  table.remove(result.diagnostics, idx)
                else
                  idx = idx + 1
                end
              end

              vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
            end,
          },
        },
        terraformls = {},

        helm_ls = {
          settings = {
            ["helm-ls"] = {
              yamlls = {
                enabled = true,
                config = yaml_setting,
              },
            },
          },
        },
        yamlls = {
          settings = {
            redhat = { telemetry = { enabled = false } },
            yaml = yaml_setting,
          },
        },
      },
      setup = {
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        eslint = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "eslint" then
              client.server_capabilities.documentFormattingProvider = true
              -- elseif client.name == "tsserver" then
              --   client.server_capabilities.documentFormattingProvider = false
              -- elseif client.name == "vtsls" then
              --   client.server_capabilities.documentFormattingProvider = false
            end
          end)
        end,
        terraformls = function()
          require("lazyvim.util").lsp.on_attach(function(client)
            if client.name == "terraformls" then
              client.server_capabilities.semanticTokensProvider = nil -- turn off semantic tokens
            end
          end)
        end,
        yamlls = function(_, opts)
          ---@diagnostic disable-next-line: unused-local
          LazyVim.lsp.on_attach(function(client, buffer)
            if vim.bo[buffer].filetype == "helm" then
              vim.schedule(function()
                vim.cmd("LspStop ++force yamlls")
              end)
            end
          end, "yamlls")

          local cfg = require("yaml-companion").setup({
            builtin_matchers = {
              kubernetes = { enabled = true },
            },

            -- schemas available in Telescope picker
            schemas = {
              -- not loaded automatically, manually select with
              -- :Telescope yaml_schema
              {
                name = "Argo CD Application",
                uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/argoproj.io/application_v1alpha1.json",
              },
              {
                name = "SealedSecret",
                uri = "https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/bitnami.com/sealedsecret_v1alpha1.json",
              },
              -- schemas below are automatically loaded, but added
              -- them here so that they show up in the statusline
              {
                name = "Kustomization",
                uri = "https://json.schemastore.org/kustomization.json",
              },
              {
                name = "GitHub Workflow",
                uri = "https://json.schemastore.org/github-workflow.json",
              },
            },
            lspconfig = opts,
          })
          require("lspconfig")["yamlls"].setup(cfg)
          require("telescope").load_extension("yaml_schema")
          return true
        end,
      },
    },
  },

  -- LSP keymaps
  {
    "neovim/nvim-lspconfig",
    opts = function()
      local keys = require("lazyvim.plugins.lsp.keymaps").get()
      keys[#keys + 1] = {
        "gr",
        LazyVim.pick("lsp_references", { jump_type = "never" }),
        desc = "References by LSP",
      }
    end,
  },
}
