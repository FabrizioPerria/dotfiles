local function prompt()
  vim.fn.input("Condition: ")
end

return {
  {
    "mfussenegger/nvim-dap",
    config = function()
      local dap = require("dap")
      local codelldb = require("mason-registry").get_package("codelldb"):get_install_path() .. "/codelldb"
      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb,
          args = { "--port", "${port}" },
        },
      }
      dap.configurations.c = {
        {
          name = "Debug with codelldb",
          type = "codelldb",
          request = "launch",
          program = "/Applications/AudioPluginHost.app/Contents/MacOS/AudioPluginHost",
          -- program = function()
          --     return vim.fn.input({
          --         prompt = 'Path to executable: ',
          --         default = vim.fn.getcwd() .. '/',
          --         completion = 'file',
          --     })
          -- end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }
      dap.configurations.cpp = dap.configurations.c
      dap.adapters.python = {
        type = "executable",
        command = "./bin/python",
        args = {
          "-m",
          "debugpy.adapter",
        },
      }

      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch file",
          program = "${file}", -- This configuration will launch the current file if used.
        },
      }
      vim.g.dap_virtual_text = true
    end,

    keys = {
      { "<F5>", ":DapContinue<CR>", "Run/Continue Debug" },
      {
        "<F8>",
        function()
          require("dap").set_breakpoint(prompt())
        end,
        "Conditional Breakpoint",
      },
      { "<F9>", ":DapToggleBreakpoint<CR>", "Toggle Breakpoint" },
      { "<F10>", ":DapStepOver<CR>", "Debug step over" },
      { "<F11>", ":DapStepInto<CR>", "Debug step into" },
      { "<C-F11>", ":DapStepOut<CR>", "Debug step out" },
      { "<F12>", ':DapTerminate<CR>:lua require"dapui".close()<CR>', "" },
    },
  },
}
