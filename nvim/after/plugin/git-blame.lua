if not vim.g.vscode then
    require('gitblame').setup({
        enabled = false,
        message_template = '[<sha>] <summary> • <author> • <date>'
    })

    vim.g.gitblame_enabled = false
end
