return {
  {
    "akinsho/bufferline.nvim",
    event = "VeryLazy",
    keys = {
      { "<leader>b1", "<CMD>BufferLineGoToBuffer 1<CR>", desc = "Switch to buffer 1" },
      { "<leader>b2", "<CMD>BufferLineGoToBuffer 2<CR>", desc = "Switch to buffer 2" },
      { "<leader>b3", "<CMD>BufferLineGoToBuffer 3<CR>", desc = "Switch to buffer 3" },
      { "<leader>b4", "<CMD>BufferLineGoToBuffer 4<CR>", desc = "Switch to buffer 4" },
      { "<leader>b5", "<CMD>BufferLineGoToBuffer 5<CR>", desc = "Switch to buffer 5" },
      { "<leader>b6", "<CMD>BufferLineGoToBuffer 6<CR>", desc = "Switch to buffer 6" },
      { "<leader>b7", "<CMD>BufferLineGoToBuffer 7<CR>", desc = "Switch to buffer 7" },
      { "<leader>b8", "<CMD>BufferLineGoToBuffer 8<CR>", desc = "Switch to buffer 8" },
      { "<leader>b9", "<CMD>BufferLineGoToBuffer 9<CR>", desc = "Switch to buffer 9" },
      -- stylua: ignore
      { "<leader>b$", "<CMD>BufferLineGoToBuffer -1<CR>", desc = "Switch to last buffer" },
      { "<leader>bg", "<CMD>BufferLinePick<CR>", desc = "Buffer pick" },
      { "<leader>b>", "<CMD>BufferLineMoveNext<CR>", desc = "Buffer move to next" },
      { "<leader>b<", "<CMD>BufferLineMovePrev<CR>", desc = "Buffer move to previous" },
    },
    init = function()
      local bufline = require("catppuccin.groups.integrations.bufferline")
      function bufline.get()
        return bufline.get_theme()
      end
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      opts.sections.lualine_z = {
        {
          function()
            local schema = require("yaml-companion").get_buf_schema(0)
            if schema.result[1].name == "none" then
              return ""
            end
            return schema.result[1].name
          end,
        },
        opts.sections.lualine_z,
      }
    end,
  },
}
