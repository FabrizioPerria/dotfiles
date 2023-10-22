local wk = require("which-key")

wk.register({
    ['<leader>'] = {
        ["f"] = {
            ["name"] = '+file',
            [""] = { function() vim.lsp.buf.format() end, 'Format file', mode = { 'n' } },
            ['b'] = { ':Telescope buffers<CR>', 'Show buffers', mode = { 'n' } },
            ['f'] = { require('telescope.builtin').find_files, 'Fuzzy file search', mode = { 'n' } },
            ['g'] = { require('telescope.builtin').git_files, 'Fuzzy file search in git repository', mode = { 'n' } },
            ['s'] = { function() require('telescope.builtin').live_grep({ search_dir = '%:p:h' }) end, 'Grep search', mode = { 'n' } },
            ['v'] = { ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>', 'Show file browser', mode = { 'n' } },
            ['k'] = { require('telescope.builtin').keymaps, 'Show keymaps', mode = { 'n' } },
            ['h'] = { require('telescope.builtin').help_tags, 'Find man pages for vim commands', mode = { 'n' } },
            ['p'] = { ":lua require'telescope'.extensions.project.project{}<CR>", ' ', mode = { 'n' } },
        },

        ["g"] = {
            ["name"] = '+git',

            [""] = { ":vertical Git | vertical resize 60<CR>", ' ', mode = { "n" } },
            ["co"] = { ':Git commit -m ""<Left>', ' ', mode = { "n" } },
            ["g"] = { ":Git pull --rebase", ' ', mode = { "n" } },
            ["p"] = { ":Git push -u origin ", ' ', mode = { "n" } },
            ["m"] = { ":Git merge ", ' ', mode = { "n" } },
            ["L"] = { ":vertical Git log | vertical resize 100<CR>", ' ', mode = { "n" } },
            ["t"] = { ":GV<CR>", ' ', mode = { "n" } },
            ["a"] = { ":Gwrite<CR>", ' ', mode = { "n" } },
            ["-"] = { ":Gread<CR>", ' ', mode = { "n" } },
            ["ch"] = { ":Git checkout ", ' ', mode = { "n" } },
            ["B"] = { ":Telescope git_branches<CR>", ' ', mode = { "n" } },
            ["s"] = { ":Telescope git_stash<CR>", ' ', mode = { "n" } },
            ["sa"] = { ":Git stash<CR>", ' ', mode = { "n" } },
            ["sp"] = { ":Git stash pop<CR>", ' ', mode = { "n" } },
            ["f"] = { ":Telescope git_files<CR>", ' ', mode = { "n" } },
            ["l"] = { ":Telescope git_commits<CR>", ' ', mode = { "n" } },
            ['d'] = { function()
                if next(require('diffview.lib').views) == nil then
                    vim.cmd('DiffviewOpen')
                else
                    vim.cmd(
                        'DiffviewClose')
                end
            end, ' ', mode = { "n" } },
            ['<Left>'] = { require("diffview.actions").diffget("ours"), ' ', mode = { 'n', 'x' } },
            ['<Right>'] = { require("diffview.actions").diffget("theirs"), ' ', mode = { 'n', 'x' } },
            ['<Down>'] = { require("diffview.actions").diffput("local"), ' ', mode = { 'n', 'x' } },
            ['<Up>'] = { '<C-j>u', ' ', mode = { 'n', 'x' } },
            ["b"] = { ':GitBlameToggle<CR>', '', mode = { 'n', 'x' } }
        },

        ["r"] = {
            ["name"] = '+refactoring',

            [""] = { function() require('telescope').extensions.refactoring.refactors() end, '', mode = { "n", "x" }, },
            ["r"] = { function() require('refactoring').select_refactor() end, 'Select refactor type', mode = { "n", "x" }, },
            ["e"] = { ":Refactor extract ", 'Extract Selection', mode = { "x" }, },
            ["f"] = { ":Refactor extract_to_file ", "Extract selection to file", mode = { "x" }, },
            ["F"] = { ":Refactor inline_func", 'Inline Function', mode = { "n", "x" }, },
            ["v"] = { ":Refactor extract_var ", 'Extract selected variable', mode = { "x" }, },
            ["V"] = { ":Refactor inline_var", 'Inline variable', mode = { "n", "x" }, },
            ["b"] = { ":Refactor extract_block", 'Extract block', mode = { "x" }, },
            ["bf"] = { ":Refactor extract_block_to_file", 'Extract block to file', mode = { "x" }, }
        },

        ["p"] = {
            ["name"] = '+print',

            ['p'] = { function() require('refactoring').debug.printf({ below = false }) end, ' ', mode = { "n" } },
            ['P'] = { function() require('refactoring').debug.printf({ below = true }) end, ' ', mode = { "n" } },
            ['v'] = { function() require('refactoring').debug.print_var() end, ' ', mode = { "x", "n" } },
            ['c'] = { function() require('refactoring').debug.cleanup({}) end, ' ', mode = { "n" } },
        },

        ["h"] = {
            ["name"] = "+harpoon",
            ["a"]    = { require("harpoon.mark").add_file, 'Add file' },
            ["s"]    = { require("harpoon.ui").toggle_quick_menu, 'Show files' },
            ["1"]    = { function() require("harpoon.ui").nav_file(1) end, 'Open mark 1' },
            ["2"]    = { function() require("harpoon.ui").nav_file(2) end, 'Open mark 2' },
            ["3"]    = { function() require("harpoon.ui").nav_file(3) end, 'Open mark 3' },
            ["4"]    = { function() require("harpoon.ui").nav_file(4) end, 'Open mark 4' },
            ["5"]    = { function() require("harpoon.ui").nav_file(1) end, 'Open mark 5' },
            ["6"]    = { function() require("harpoon.ui").nav_file(2) end, 'Open mark 6' },
            ["7"]    = { function() require("harpoon.ui").nav_file(3) end, 'Open mark 7' },
            ["8"]    = { function() require("harpoon.ui").nav_file(4) end, 'Open mark 8' },
            ["9"]    = { function() require("harpoon.ui").nav_file(4) end, 'Open mark 9' },
        },
        ["t"] = {
            ["name"] = '+tabline',
            ['<Left>'] = { ':tabprev<CR>', 'Move to previous tab', mode = { 'n' } },
            ['<Right>'] = { ':tabnext<CR>', 'Move to next tab', mode = { 'n' } },
            ['q'] = { ':tabclose<CR>', 'Move to next tab', mode = { 'n' } },
        },
        ["ca"] = {
            ['mir'] = { ":CellularAutomaton make_it_rain<CR>", 'Make it rain', mode = { "n" } },
            ['gol'] = { ":CellularAutomaton game_of_life<CR>", 'Game of life', mode = { "n" } },
            ['scr'] = { ":CellularAutomaton scramble<CR>", 'Scramble', mode = { "n" } },
            ['sli'] = { ":CellularAutomaton slide<CR>", 'Slide', mode = { "n" } },
        }
    }
})
