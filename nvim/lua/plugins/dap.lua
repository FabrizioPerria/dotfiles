local function prompt()
    vim.fn.input("Condition: ")
end

return {
    {
        "mfussenegger/nvim-dap",
        dependencies = {
            "nvim-neotest/nvim-nio",
            "leoluz/nvim-dap-go",
            "mfussenegger/nvim-dap-python",
            "rcarriga/nvim-dap-ui",
            "theHamsta/nvim-dap-virtual-text",
        },
        config = function()
            require("dap-go").setup()
            require("dap-python").setup()
            local dap = require("dap")
            local dapui = require("dapui")
            dapui.setup()
            dap.listeners.after.event_initialized["dapui_config"] = function()
                dapui.open()
            end
            dap.listeners.before.event_terminated["dapui_config"] = function()
                dapui.close()
            end
            dap.listeners.before.event_exited["dapui_config"] = function()
                dapui.close()
            end
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

            local bash_apater_path = require("mason-registry").get_package("bash-debug-adapter"):get_install_path()
            local bash_adapter = bash_apater_path .. "/bash-debug-adapter"
            local bashdb_path = bash_apater_path .. "/extension/bashdb_dir"
            dap.adapters.sh = {
                type = "executable",
                command = bash_adapter,
            }
            dap.configurations.sh = {
                {
                    name = "Launch Bash debugger",
                    type = "sh",
                    request = "launch",
                    program = "${file}",
                    cwd = "${fileDirname}",
                    pathBashdb = bashdb_path .. "/bashdb",
                    pathBashdbLib = bashdb_path,
                    pathBash = "bash",
                    pathCat = "cat",
                    pathMkfifo = "mkfifo",
                    pathPkill = "pkill",
                    env = {},
                    args = {},
                    -- showDebugOutput = true,
                    -- trace = true,
                },
            }
            vim.g.dap_virtual_text = true
        end,
        lazy = true,
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
