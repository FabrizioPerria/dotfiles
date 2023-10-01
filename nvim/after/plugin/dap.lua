require('mason').setup()
require('mason-nvim-dap').setup({
    ensure_installed = {
        'python',
        'codelldb'
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
                default = vim.fn.getcwd() .. '/',
                completion = 'file',
            })
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
    },
}
dap.configurations.cpp = dap.configurations.c

require('dap-python').setup('/opt/homebrew/bin/python3')

vim.keymap.set('n', '<F4>', ':DapToggleBreakpoint<CR>')
vim.keymap.set('n', '<F5>', ':DapContinue<CR>')
vim.keymap.set('n', '<F10>', ':DapStepOver<CR>')
vim.keymap.set('n', '<F12>', ':DapTerminate<CR>')


vim.api.nvim_set_hl(0, "DapStoppedLinehl", { bg = "#555530" })
vim.fn.sign_define("DapStopped", { text = 'S', texthl = "Error", linehl = "DapStoppedLinehl", numhl = "" })
vim.fn.sign_define('DapBreakpoint', {text='•', texthl='Error', linehl='', numhl=''})
