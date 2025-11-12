return {
  {
    "mfussenegger/nvim-dap",
    opts = function()
      local dap = require("dap")
      dap.adapters["pwa-node"] = {
        type = "server",
        -- https://github.com/mxsdev/nvim-dap-vscode-js/issues/46#issuecomment-1573554662
        host = "127.0.0.1",
        port = "${port}",
        executable = {
          command = "node",
          -- 💀 Make sure to update this path to point to your installation
          args = {
            -- require("mason-registry").get_package("js-debug-adapter"):get_install_path()
            --   .. "/js-debug/src/dapDebugServer.js",
            -- "${port}",
          },
        },
      }
    end,
  },
}
