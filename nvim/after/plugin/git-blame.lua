require('gitblame').setup({
    enabled = true,
    message_template = '[<sha>] <summary> • <author> • <date>'
})

vim.keymap.set("n", "<leader>gb", ':GitBlameToggle<CR>')

