return {
  -- snippets
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
    opts = {
      region_check_events = "InsertEnter",
    },
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "hrsh7th/cmp-cmdline" },
    opts = function(_, opts)
      local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
      end

      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      local luasnip = require("luasnip")
      local cmp = require("cmp")
      -- opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))

      opts.mapping = vim.tbl_deep_extend("force", opts.mapping, {
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
        ["<C-d>"] = cmp.mapping.complete(),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            -- You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
            cmp.select_next_item({ behavior = cmp.SelectBehavior.Insert })
          -- You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
          -- this way you will only jump inside the snippet region
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          elseif has_words_before() then
            cmp.complete()
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
      })

      -- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer", keyword_length = 3 },
        },
      })

      -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
      ---@diagnostic disable-next-line: missing-fields
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline", keyword_length = 3 },
        }),
      })
    end,
  },
}
