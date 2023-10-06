local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.git_files, {})

vim.keymap.set('n', '<leader>fs', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)

vim.keymap.set('n', '<leader>hh', builtin.help_tags, {})

vim.keymap.set('n', '<leader>fv', ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>')
local telescope = require('telescope')
telescope.setup({
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
    defaults = {
        mappings = {
        },
        vimgrep_arguments = {
            'rg',
            '--color=never',
            '--no-heading',
            '--with-filename',
            '--line-number',
            '--column',
            '--smart-case',
            '--hidden',
        },
        preview = { treesitter = true },
    },
    pickers = {
        find_files = {
            find_command = {
                'fd',
                '.',
                '--type',
                'f',
                '--hidden',
                '--strip-cwd-prefix',
                '--exclude',
                'node_modules',
                '--exclude',
                'Library',
                '--exclude',
                '.DS_Store',
                '--exclude',
                '.Trash',
                '--exclude',
                '.cache',
                '--exclude',
                '.git',
                '--exclude',
                '.local',
                '--exclude',
                '.nuget'
            },
        },
    }
})

telescope.load_extension("fzf")
telescope.load_extension ( "file_browser" )
telescope.load_extension ( "refactoring" )
