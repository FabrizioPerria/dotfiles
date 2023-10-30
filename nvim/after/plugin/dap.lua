if not vim.g.vscode then
    require('mason').setup()
    require('mason-nvim-dap').setup({
        ensure_installed = {
            'python',
            'codelldb',
        }
    })

    local dap = require('dap')
    local dapui = require('dapui')
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

    local codelldb = require('mason-registry').get_package('codelldb'):get_install_path() .. '/codelldb'
    dap.adapters.codelldb = {
        type = 'server',
        port = '${port}',
        executable = {
            command = codelldb,
            args = { '--port', '${port}' },
        },
    }
    dap.configurations.c = {
        {
            name = 'Debug with codelldb',
            type = 'codelldb',
            request = 'launch',
            program = function()
                return vim.fn.input({
                    prompt = 'Path to executable: ',
                    -- default = vim.fn.getcwd() .. '/',
                    default = '/Applications/AudioPluginHost.app/Contents/MacOS/AudioPluginHost',
                    completion = 'file',
                })
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = false,
        },
    }
    dap.configurations.cpp = dap.configurations.c

    local netcoredbg =
    '/usr/local/bin/netcoredbg' --require('mason-registry').get_package('netcoredbg'):get_install_path() .. '/netcoredbg'
    dap.adapters.coreclr = {
        type = 'executable',
        command = netcoredbg,
        args = { '--interpreter=vscode' }
    }

    dap.configurations.cs = {
        {
            type = "coreclr",
            name = "launch - netcoredbg",
            request = "launch",
            program = function()
                local cwd = vim.fn.getcwd()
                local d = vim.fn.fnamemodify(cwd, ":t")
                return vim.fn.input('Path to dll: ', cwd .. '/bin/Debug/net7.0/' .. d .. '.dll', 'file')
            end,
            cwd = '${workspaceFolder}',
            stopOnEntry = true,
        },
    }

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

    vim.keymap.set('n', '<F5>', ':DapContinue<CR>', { desc = "Run/Continue Debug" })
    vim.keymap.set('n', '<F8>', ":lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>",
        { desc = 'Conditional Breakpoint' })
    vim.keymap.set('n', '<F9>', ':DapToggleBreakpoint<CR>', { desc = "Toggle Breakpoint" })
    vim.keymap.set('n', '<F10>', ':DapStepOver<CR>', { desc = "Debug step over" })
    vim.keymap.set('n', '<F11>', ':DapStepInto<CR>', { desc = "Debug step into" })
    vim.keymap.set('n', '<C-F11>', ':DapStepOut<CR>', { desc = "Debug step out" })
    vim.keymap.set('n', '<F12>', ':DapTerminate<CR>:lua require"dapui".close()<CR>"', { desc = "Stop and quit debug" })
    vim.keymap.set('n', '<s-F5>', ':DapTerminate<CR>:lua require"dapui".close()<CR>"', { desc = "Stop and quit debug" })


    vim.fn.sign_define('DapBreakpoint',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition',
        { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', {
        text = '',
        texthl = 'DapLogPoint',
        linehl = 'DapLogPoint',
        numhl = 'DapLogPoint'
    })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
end
