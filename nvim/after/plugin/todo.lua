require('todo-comments').setup()

vim.keymap.set('n', '<leader>tt', ':TodoTelescope<CR>', {desc='Show todo list'})