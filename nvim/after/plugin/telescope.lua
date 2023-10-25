local telescope = require('telescope')
telescope.setup({

    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
        file_browser = {
            hidden = true,
            hijack_netrw = true,

        },
        fzf = {
            fuzzy = true,
            override_generic_sorter = true,
            override_file_sorter = true,
            case_mode = 'smart_case'
        }
    },
    defaults = {
        path_display = { 'truncate' },
        mappings = {
            i = {
                -- ["<C-u>"] = require('telescope.actions').preview_scrolling_up,
                -- ["<C-d>"] = require('telescope.actions').preview_scrolling_down,
                ["<C-a>"] = require('telescope.actions').preview_scrolling_left,
                ["<C-l>"] = require('telescope.actions').preview_scrolling_right,
            },
            n = {
                -- ["<C-u>"] = require('telescope.actions').preview_scrolling_up,
                -- ["<C-d>"] = require('telescope.actions').preview_scrolling_down,
                ["<C-a>"] = require('telescope.actions').preview_scrolling_left,
                ["<C-l>"] = require('telescope.actions').preview_scrolling_right,
            }
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
        buffers = {
            mappings = {
                n = {
                    ['<C-x>'] = require('telescope.actions').delete_buffer,
                },
                i = {
                    ['<C-x>'] = require('telescope.actions').delete_buffer,
                }
            }
        },
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
    },
})

telescope.load_extension("fzf")
telescope.load_extension("file_browser")
telescope.load_extension("cder")
telescope.load_extension("refactoring")
telescope.load_extension("ui-select")
telescope.load_extension("undo")

-- telescope.load_extension("projects")
