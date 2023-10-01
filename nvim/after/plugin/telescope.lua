local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>pf', builtin.find_files, { })
-- vim.keymap.set('n', '<leader>pf', ':Telescope find_files follow=true no_ignore=true hidden=true<CR>')
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
vim.keymap.set('n', '<leader>vh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>pv', ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>')
local browser_actions = require('telescope').extensions.file_browser.actions

require('telescope').setup({
    extensions = {
        file_browser = {
            hijack_netrw = true,
            hidden=true
        }
    }
})

require('telescope').load_extension "file_browser"
