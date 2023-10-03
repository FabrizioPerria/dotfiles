local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})

vim.keymap.set('n', '<C-f>', builtin.git_files, {})

vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set('n', '<leader>hh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>fv', ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>')

require('telescope').setup({
    extensions = {
        file_browser = {
            hijack_netrw = true,
            hidden = true
        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case'
        }
    },
    pickers = {
        find_files = {
            hidden = true
        }
    }
})

require('telescope').load_extension "file_browser"
require('telescope').load_extension "fzf"
