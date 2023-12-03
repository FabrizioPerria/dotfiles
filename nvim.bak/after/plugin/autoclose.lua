require("autoclose").setup({
    keys = {
        ['<'] = { escape = true, close = true, pair = '<>', disabled_filetypes = { 'c', 'cpp', 'h', 'hpp', 'cs', 'py',
            'lua' } }
    },
    options = {
    }
})
