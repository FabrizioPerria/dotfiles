return { 
    'f-person/git-blame.nvim',
    config = function()
        require('gitblame').setup({
            enabled = false,
            message_template = '[<sha>] <summary> • <author> • <date>'
        })

        vim.g.gitblame_enabled = false
    end,
    enabled = vim.g.vscode == 0 
}