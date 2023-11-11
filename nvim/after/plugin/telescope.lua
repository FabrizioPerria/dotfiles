local telescope = require('telescope')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')

telescope.setup({

    extensions = {
        ["ui-select"] = {
            require("telescope.themes").get_dropdown {}
        },
        file_browser = {
            hidden = true,
            hijack_netrw = false,
            no_ignore = true
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
                ["<C-k>"] = actions.preview_scrolling_up,
                ["<C-j>"] = actions.preview_scrolling_down,
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,

            },
            n = {
                ["<C-k>"] = actions.preview_scrolling_up,
                ["<C-j>"] = actions.preview_scrolling_down,
                ["<C-h>"] = actions.preview_scrolling_left,
                ["<C-l>"] = actions.preview_scrolling_right,
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
                    ['d'] = actions.delete_buffer,
                },
                i = {
                    ['<A-d>'] = actions.delete_buffer,
                }
            }
        },
        git_status = {
            mappings = {
                n = {
                    ['d'] = function(prompt_bufnr)
                        local selection = action_state.get_selected_entry(prompt_bufnr)
                        os.execute('git checkout -- ' .. selection.value)
                        actions._close(prompt_bufnr, true)
                        require('telescope.builtin').git_status()
                    end,
                },
                i = {
                    ['<A-d>'] = function(prompt_bufnr)
                        local selection = action_state.get_selected_entry(prompt_bufnr)
                        os.execute('git checkout -- ' .. selection.value)
                        actions._close(prompt_bufnr, true)
                        require('telescope.builtin').git_status()
                    end,
                },
            },
        },
        find_files = {
            find_command = {
                'fd',
                '.',
                '--type',
                'f',
                '--hidden',
                '--no-ignore',
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
telescope.load_extension("refactoring")
telescope.load_extension("ui-select")
telescope.load_extension("undo")
telescope.load_extension("dap")
