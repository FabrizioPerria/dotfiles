require('toggleterm').setup({
    direction = 'float'
})

vim.keymap.set('n', '<leader>t', ':ToggleTerm<CR>',{desc='Open float terminal'})
