return {

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    build = (not jit.os:find("Windows"))
        and "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp"
      or nil,
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
      region_check_events = "InsertEnter",
    },
    -- stylua: ignore
    keys = {
      {
        "<tab>",
        function()
          return require("luasnip").jumpable(1) and "<Plug>luasnip-jump-next" or "<tab>"
        end,
        expr = true, silent = true, mode = "i",
      },
      { "<tab>", function() require("luasnip").jump(1) end, mode = "s" },
      { "<s-tab>", function() require("luasnip").jump(-1) end, mode = { "i", "s" } },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false,
    event = { "InsertEnter", "CmdlineEnter" },
    -- these dependencies will only be loaded when cmp loads
    -- dependencies are always lazy-loaded unless specified otherwise
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "hrsh7th/cmp-nvim-lsp-signature-help",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      -- Snippets source for nvim-cmp
      "saadparwaiz1/cmp_luasnip",
      -- Vs Code Like Icons for autocompletion
      "onsails/lspkind.nvim",
    },
    opts = function()
      vim.api.nvim_set_hl(0, "CmpGhostText", { link = "Comment", default = true })
      local cmp = require("cmp")
      local defaults = require("cmp.config.default")()
      local luasnip = require("luasnip")
      local lspkind = require("lspkind")

      -- helper function for super tab functionality
      local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer", keyword_length = 3 },
        },
      })

      -- Use cmdline & path source for ":" (if you enabled `native_menu`, this won"t work anymore).
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_length = 3 },
        }),
      })

      return {
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        view = {
          entries = { name = "custom", selection_order = "near_cursor" },
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-a>"] = cmp.mapping({
            c = function()
              vim.api.nvim_feedkeys(t("<Home>"), "n", true)
            end,
          }),
          ["<C-e>"] = cmp.mapping({
            c = function()
              vim.api.nvim_feedkeys(t("<End>"), "n", true)
            end,
            i = cmp.mapping.abort(),
          }),
          ["<C-b>"] = cmp.mapping({
            c = function()
              vim.api.nvim_feedkeys(t("<Left>"), "n", true)
            end,
          }),
          ["<C-f>"] = cmp.mapping({
            c = function()
              vim.api.nvim_feedkeys(t("<Right>"), "n", true)
            end,
            i = cmp.mapping.scroll_docs(4),
          }),
          ["<C-u>"] = cmp.mapping({
            i = cmp.mapping.scroll_docs(-4),
          }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          -- ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-d>"] = cmp.mapping.complete(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
            select = true,
          }),
          ["<Tab>"] = cmp.mapping(function(fallback)
            -- local copilot_keys = vim.fn["copilot#Accept"]()
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            -- elseif copilot_keys ~= "" and type(copilot_keys) == "string" then
            -- vim.api.nvim_feedkeys(copilot_keys, "i", true)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "nvim_lsp_signature_help" },
          { name = "nvim_lua" },
          { name = "luasnip", option = { show_autosnippets = true } },
          { name = "path" },
          { name = "buffer", option = { keyword_length = 3 } },
          { name = "codeium" },
        }),
        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            -- maxwidth = 50,
            -- ellipsis_char = "...",
          }),
        },
        experimental = {
          -- ghost_text = false,
          ghost_text = {
            hl_group = "CmpGhostText",
          },
        },
        sorting = defaults.sorting,
      }
    end,
  },
}
