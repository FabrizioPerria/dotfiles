return { 
    'prichrd/netrw.nvim',
    config = function() require('netrw').setup({}) end,
    enabled = vim.g.vscode == 0,
}
