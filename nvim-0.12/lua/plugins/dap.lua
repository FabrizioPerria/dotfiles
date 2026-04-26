local function prompt()
    vim.fn.input("Condition: ")
end

require("dapui").setup({
    icons = { expanded = "▾", collapsed = "▸" },
    mappings = {
        expand = { "<CR>", "<2-LeftMouse>" },
        open = "o",
        remove = "d",
        edit = "e",
        repl = "r",
        toggle = "t",
        hover = "K",
    },
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.5 },
                { id = "stacks", size = 0.25 },
                { id = "watches", size = 0.25 },
            },
            size = 40,
            position = "left",
        },
        {
            elements = { { id = "console", size = 1 } },
            size = 10,
            position = "bottom",
        },
    },
})

require("dap-go").setup()
require("dap-python").setup("python")

local dap = require("dap")
local dapui = require("dapui")

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

local bash_adapter_path = vim.fn.expand("$MASON/packages/bash-debug-adapter")
local bash_adapter = bash_adapter_path .. "/bash-debug-adapter"
local bashdb_path = bash_adapter_path .. "/extension/bashdb_dir"
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

-- netcoredbg: prefer Mason install, fall back to vim.pack location on macOS
local netcoredbg = vim.fn.expand("$MASON/packages/netcoredbg/netcoredbg")
if vim.fn.has("mac") == 1 then
    local pack_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/netcoredbg-macOS-arm64.nvim/netcoredbg/netcoredbg"
    if vim.fn.filereadable(pack_path) == 1 then
        netcoredbg = pack_path
    end
end

dap.adapters.coreclr = {
    type = "executable",
    command = netcoredbg,
    args = { "--interpreter=vscode" },
}
dap.adapters.netcoredbg = {
    type = "executable",
    command = netcoredbg,
    args = { "--interpreter=vscode" },
}

dap.configurations.cs = {
    {
        type = "coreclr",
        name = "Launch",
        request = "launch",
        program = function()
            return vim.fn.input("Path to dll: ", vim.fn.getcwd() .. "/bin/Debug/", "file")
        end,
    },
}

vim.g.dap_virtual_text = true

require("powershell").setup({
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
})

require("netcoredbg-macOS-arm64").setup(require("dap"))

-- Keymaps
vim.keymap.set("n", "<F5>", ":DapContinue<CR>", { desc = "Run/Continue Debug" })
vim.keymap.set("n", "<F8>", function()
    require("dap").set_breakpoint(prompt())
end, { desc = "Conditional Breakpoint" })
vim.keymap.set("n", "<F9>", ":DapToggleBreakpoint<CR>", { desc = "Toggle Breakpoint" })
vim.keymap.set("n", "<F10>", ":DapStepOver<CR>", { desc = "Debug step over" })
vim.keymap.set("n", "<F11>", ":DapStepInto<CR>", { desc = "Debug step into" })
vim.keymap.set("n", "<C-F11>", ":DapStepOut<CR>", { desc = "Debug step out" })
vim.keymap.set("n", "<F12>", ':DapTerminate<CR>:lua require"dapui".close()<CR>', { desc = "Stop debugger" })
vim.keymap.set("n", "<leader>dh", function()
    require("dapui").eval()
end, { desc = "Hover variable" })
