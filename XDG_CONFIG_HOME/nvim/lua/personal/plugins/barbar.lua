return {
  {
    "romgrk/barbar.nvim",
    -- enabled = false,
    event = "VeryLazy",
    keys = {
      -- Move to previous/next
      { "H", "<CMD>BufferPrevious<CR>", noremap = true, silent = true, desc = "Prev buffer" },
      { "L", "<CMD>BufferNext<CR>", noremap = true, silent = true, desc = "Next buffer" },
      { "[b", "<CMD>BufferPrevious<CR>", noremap = true, silent = true, desc = "Prev buffer" },
      { "]b", "<CMD>BufferNext<CR>", noremap = true, silent = true, desc = "Next buffer" },
      -- Re-order to previous/next
      { "<leader><", "<CMD>BufferMovePrevious<CR>", noremap = true, silent = true, desc = "Move to previous" },
      { "<leader>>", "<CMD>BufferMoveNext<CR>", noremap = true, silent = true, desc = "Move to next" },
      -- Goto buffer in position...
      { "<leader>a1", "<CMD>BufferGoto 1<CR>", noremap = true, silent = true, desc = "Switch to buffer 1" },
      { "<leader>a2", "<CMD>BufferGoto 2<CR>", noremap = true, silent = true, desc = "Switch to buffer 2" },
      { "<leader>a3", "<CMD>BufferGoto 3<CR>", noremap = true, silent = true, desc = "Switch to buffer 3" },
      { "<leader>a4", "<CMD>BufferGoto 4<CR>", noremap = true, silent = true, desc = "Switch to buffer 4" },
      { "<leader>a5", "<CMD>BufferGoto 5<CR>", noremap = true, silent = true, desc = "Switch to buffer 5" },
      { "<leader>a6", "<CMD>BufferGoto 6<CR>", noremap = true, silent = true, desc = "Switch to buffer 6" },
      { "<leader>a7", "<CMD>BufferGoto 7<CR>", noremap = true, silent = true, desc = "Switch to buffer 7" },
      { "<leader>a8", "<CMD>BufferGoto 8<CR>", noremap = true, silent = true, desc = "Switch to buffer 8" },
      { "<leader>a9", "<CMD>BufferGoto 9<CR>", noremap = true, silent = true, desc = "Switch to buffer 9" },
      { "<leader>a0", "<CMD>BufferLast<CR>", noremap = true, silent = true, desc = "Switch to last buffer" },
      -- Pin/unpin buffer
      { "<leader>ap", "<CMD>BufferPin<CR>", noremap = true, silent = true, desc = "Pin buffer" },
      -- Close buffer
      { "<leader>ac", "<CMD>BufferClose<CR>", noremap = true, silent = true, desc = "Close buffer" },
      -- Wipeout buffer
      --                 :BufferWipeout<CR>
      -- Close commands
      --                 :BufferCloseAllButCurrent<CR>
      --                 :BufferCloseAllButPinned<CR>
      --                 :BufferCloseAllButCurrentOrPinned<CR>
      --                 :BufferCloseBuffersLeft<CR>
      --                 :BufferCloseBuffersRight<CR>
      -- Magic buffer-picking mode
      { "<leader>p", "<CMD>BufferPick<CR>", noremap = true, silent = true, desc = "Buffer pick" },
      -- Sort automatically by...
      {
        "<leader>bb",
        "<CMD>BufferOrderByBufferNumber<CR>",
        noremap = true,
        silent = true,
        desc = "Order buffer by buffer number",
      },
      {
        "<leader>bd",
        "<CMD>BufferOrderByDirectory<CR>",
        noremap = true,
        silent = true,
        desc = "Order buffer by directory",
      },
      {
        "<leader>bl",
        "<CMD>BufferOrderByLanguage<CR>",
        noremap = true,
        silent = true,
        desc = "Order buffer by language",
      },
      {
        "<leader>bw",
        "<CMD>BufferOrderByWindowNumber<CR>",
        noremap = true,
        silent = true,
        desc = "Order buffer by window number",
      },

      -- Other:
      -- :BarbarEnable - enables barbar (enabled by default)
      -- :BarbarDisable - very bad command, should never be used
    },
    opts = function()
      vim.api.nvim_create_autocmd("FileType", {
        callback = function(tbl)
          local set_offset = require("barbar.api").set_offset

          local bufwinid
          local last_width
          local autocmd = vim.api.nvim_create_autocmd("WinScrolled", {
            callback = function()
              bufwinid = bufwinid or vim.fn.bufwinid(tbl.buf)

              local width = vim.api.nvim_win_get_width(bufwinid)
              if width ~= last_width then
                set_offset(width, "FileTree")
                last_width = width
              end
            end,
          })

          vim.api.nvim_create_autocmd("BufWipeout", {
            buffer = tbl.buf,
            callback = function()
              vim.api.nvim_del_autocmd(autocmd)
              set_offset(0)
            end,
            once = true,
          })
        end,
        pattern = "NvimTree",
      })

      return {
        animation = true,
        auto_hide = false,
        tabpages = true,
        clickable = false,
        -- exclude_ft = {'javascript'},
        -- exclude_name = {'package.json'},
        focus_on_close = "left",
        hide = { extensions = true, inactive = false },
        highlight_alternate = false,
        highlight_inactive_file_icons = false,
        highlight_visible = true,
        icons = {
          buffer_index = true,
          buffer_number = false,
          button = false,
          diagnostics = {
            [vim.diagnostic.severity.ERROR] = { enabled = true, icon = "ﬀ" },
            [vim.diagnostic.severity.WARN] = { enabled = false },
            [vim.diagnostic.severity.INFO] = { enabled = false },
            [vim.diagnostic.severity.HINT] = { enabled = true },
          },
          filetype = {
            custom_colors = false,
            enabled = true,
          },
          separator = { left = "▎", right = "" },
          modified = { button = "●" },
          pinned = { button = "車" },
          alternate = { filetype = { enabled = false } },
          current = { buffer_index = true },
          inactive = { button = false },
          visible = { modified = { buffer_number = false } },
        },
        insert_at_end = false,
        insert_at_start = false,
        maximum_padding = 4,
        minimum_padding = 1,
        maximum_length = 30,
        semantic_letters = true,
        letters = "asdfjkl;ghnmxcvbziowerutyqpASDFJKLGHNMXCVBZIOWERUTYQP",
        no_name_title = nil,
      }
    end,
  },
}
