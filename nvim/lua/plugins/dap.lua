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
            -- python_executable = require("config.utils").find_python_executable()
            -- require("dap-python").setup(python_executable)
            require("dap-python").setup("python")
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
            local codelldb = vim.fn.expand("$MASON/packages/codelldb/codelldb")
            dap.adapters.codelldb = {
                type = "server",
                port = "${port}",
                executable = {
                    command = codelldb,
                    args = { "--port", "${port}" },
                },
            }
            dap.configurations.cpp = {
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
            dap.configurations.c = {
                {
                    type = "codelldb",
                    request = "attach",
                    name = "Run kernel",
                    targetCreateCommands = { "target create ${workspaceFolder}/kernel" },
                    processCreateCommands = { "gdb-remote localhost:1234" },
                    sourceMap = { src = "${workspaceFolder}/src" },
                },
            }

            local bash_apater_path = vim.fn.expand("$MASON/packages/bash-debug-adapter")
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
            dap.configurations.python = {
                {
                    type = "python",
                    request = "launch",
                    name = "FastAPI - Launch",
                    module = "uvicorn",
                    args = function()
                        return {
                            vim.fn.input("FastAPI app module > ", "src.main:app", "file"),
                            -- '--reload', -- doesn't work
                            "--use-colors",
                        }
                    end,
                    pythonPath = "python",
                    console = "integratedTerminal",
                    env = {
                        PYTHONPATH = "${workspaceFolder}:${workspaceFolder}/src",
                    },
                },
                {
                    type = "python",
                    request = "launch",
                    name = "Launch file",
                    program = "${file}",
                    pythonPath = "python",
                    console = "integratedTerminal",
                    env = {
                        PYTHONPATH = "${workspaceFolder}:${workspaceFolder}/src",
                    },
                },
            }
            vim.g.dap_virtual_text = true
        end,
        lazy = true,
        keys = {
            { "<F5>", ":DapContinue<CR>", desc = "Run/Continue Debug" },
            {
                "<F8>",
                function()
                    require("dap").set_breakpoint(prompt())
                end,
                desc = "Conditional Breakpoint",
            },
            { "<F9>", ":DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
            { "<F10>", ":DapStepOver<CR>", desc = "Debug step over" },
            { "<F11>", ":DapStepInto<CR>", desc = "Debug step into" },
            { "<C-F11>", ":DapStepOut<CR>", desc = "Debug step out" },
            { "<F12>", ':DapTerminate<CR>:lua require"dapui".close()<CR>', desc = "Stop debugger" },
        },
    },
}
