if not vim.g.vscode then
    local wk = require("which-key")
    vim.g.mapleader = " "

    local function match_path()
        local projects = require("telescope._extensions.project.utils").get_projects('recent')
        for _, project in pairs(projects) do
            local s, _ = string.find(vim.fn.expand(vim.api.nvim_buf_get_name(0)), project.path)
            if s == 1 then
                vim.cmd(':cd ' .. project.path)
                break
            end
        end
    end

    local function DiffViewToggle()
        if next(require('diffview.lib').views) == nil then
            vim.cmd('DiffviewOpen')
        else
            vim.cmd(
                'DiffviewClose')
        end
    end

    local function prompt()
        vim.fn.input('Condition: ')
    end

    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    local telescope = require('telescope')
    local projects = telescope.extensions.project.project
    local undo = telescope.extensions.undo.undo
    local refactoring = require('refactoring')
    local tbi = require("telescope.builtin")
    local diffview = require('diffview.actions')
    local harpoonmark = require('harpoon.mark')
    local harpoonui = require('harpoon.ui')
    local dap = require('dap')

    vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true })
    vim.keymap.set('n', '<leader>s', ':%s///gI<Left><Left><Left><Left>')
    vim.keymap.set('x', '<leader>s', ':s///gI<Left><Left><Left><Left>')

    wk.register({
        ['<F3>'] = { ':Telescope dap variables<CR>', 'List variables', mode = { 'n' } },
        ['<F4>'] = { ':Telescope dap list_breakpoints<CR>', 'List breakpoints', mode = { 'n' } },
        ['<F5>'] = { ':DapContinue<CR>', "Run/Continue Debug", mode = { 'n' } },
        ['<F6>'] = { ':Telescope dap frames<CR>', 'List frames', mode = { 'n' } },
        ['<F8>'] = { function() dap.set_breakpoint(prompt()) end, 'Conditional Breakpoint', mode = { 'n' } },
        ['<F9>'] = { ':DapToggleBreakpoint<CR>', "Toggle Breakpoint", mode = { 'n' } },
        ['<F10>'] = { ':DapStepOver<CR>', "Debug step over", mode = { 'n' } },
        ['<F11>'] = { ':DapStepInto<CR>', "Debug step into", mode = { 'n' } },
        ['<C-F11>'] = { ':DapStepOut<CR>', "Debug step out", mode = { 'n' } },
        ['<F12>'] = { ':DapTerminate<CR>:lua require"dapui".close()<CR>"', "Stop and quit debug", mode = { 'n' } },
        ['<s-F5>'] = { ':DapTerminate<CR>:lua require"dapui".close()<CR>"', "Stop and quit debug", mode = { 'n' } },

        ['J'] = { ":m \'>+1<CR>gv=gv", 'Move selected block up', mode = { 'x' } },
        ['K'] = { ":m \'<-2<CR>gv=gv", 'Move selected block down', mode = { 'x' } },
        ["Y"] = { 'yy', 'Alternative copy full line', mode = { 'n' } },

        ["<C-d>"] = { "<C-d>zz", 'Scroll down and center', mode = { 'n', 'x' } },
        ["<C-u>"] = { "<C-u>zz", 'Scroll up and center', mode = { 'n', 'x' } },

        ['<leader>'] = {
            ["f"] = {
                [""] = { vim.lsp.buf.format, 'Format file', mode = { 'n' } },
                ['f'] = { tbi.find_files, 'Fuzzy file search', mode = { 'n' } },
                ['b'] = { tbi.buffers, 'Show buffers', silent = false, mode = { 'n' } },
                ['g'] = { tbi.git_files, 'Fuzzy file search in git repository', mode = { 'n' } },
                ['r'] = { tbi.registers, 'Peek Register contents', mode = { 'n', 'v' } },
                ['s'] = { function() tbi.live_grep({ search_dir = '%:p:h' }) end, 'Grep search', mode = { 'n' } },
                ['v'] = { ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>',
                    'Show file browser', silent = false, mode = { 'n' } },
                ['k'] = { tbi.keymaps, 'Show keymaps', mode = { 'n' } },
                ['h'] = { tbi.help_tags, 'Find man pages for vim commands', mode = { 'n' } },
                ['p'] = { projects, 'Show marked projects', silent = false, mode = { 'n' } },
            },

            ['u'] = { undo, "Undo menu", mode = { 'n', 'x' } },

            ["g"] = {
                [""] = { tbi.git_status, ' ', silent = false, mode = { "n" } },
                ["co"] = { ':Git commit -S -m ""<Left>', ' ', mode = { "n" }, silent = false },
                ["g"] = { ":Git pull --rebase", ' ', silent = false, mode = { "n" } },
                ["p"] = { ":Git push -u origin ", ' ', silent = false, mode = { "n" } },
                ["m"] = { ":Git merge ", ' ', silent = false, mode = { "n" } },
                ["L"] = { ":vert Git log --show-signature | vertical resize 100<CR>", ' ', silent = false, mode = { "n" } },
                ["t"] = { ":GV<CR>", ' ', silent = false, mode = { "n" } },
                ["a"] = { ":Gwrite<CR>", ' ', silent = false, mode = { "n" } },
                ["-"] = { ":Gread<CR>", ' ', silent = false, mode = { "n" } },
                ["ch"] = { ":Git checkout ", ' ', silent = false, mode = { "n" } },
                ["B"] = { tbi.git_branches, ' ', silent = false, mode = { "n" } },
                ["s"] = { tbi.git_stash, ' ', silent = false, mode = { "n" } },
                ["sa"] = { ":Git stash<CR>", ' ', silent = false, mode = { "n" } },
                ["sp"] = { ":Git stash pop<CR>", ' ', silent = false, mode = { "n" } },
                ["f"] = { tbi.git_files, ' ', silent = false, mode = { "n" } },
                ["l"] = { tbi.git_commits, ' ', silent = false, mode = { "n" } },
                ['d'] = { DiffViewToggle, ' ', mode = { "n" } },
                ['<Left>'] = { diffview.diffget("ours"), ' ', mode = { 'n', 'x' } },
                ['<Right>'] = { diffview.diffget("theirs"), ' ', mode = { 'n', 'x' } },
                ['<Down>'] = { diffview.diffput("local"), ' ', mode = { 'n', 'x' } },
                ['<Up>'] = { '<C-j>u', ' ', mode = { 'n', 'x' } },
                ["b"] = { ':GitBlameToggle<CR>', '', silent = false, mode = { 'n', 'x' } }
            },

            ["r"] = {
                [""] = { refactoring.select_refactor, 'Select refactor type', mode = { "n", "x" }, },
                ["e"] = { ":Refactor extract ", 'Extract Selection', silent = false, mode = { "x" }, },
                ["f"] = { ":Refactor extract_to_file ", "Extract selection to file", silent = false, mode = { "x" }, },
                ["F"] = { ":Refactor inline_func", 'Inline Function', silent = false, mode = { "n", "x" }, },
                ["v"] = { ":Refactor extract_var ", 'Extract selected variable', silent = false, mode = { "x" }, },
                ["V"] = { ":Refactor inline_var", 'Inline variable', silent = false, mode = { "n", "x" }, },
                ["b"] = { ":Refactor extract_block", 'Extract block', silent = false, mode = { "x" }, },
                ["bf"] = { ":Refactor extract_block_to_file", 'Extract block to file', silent = false, mode = { "x" }, }
            },

            ["p"] = {
                ['p'] = { function() refactoring.debug.printf({ below = false }) end, ' ', mode = { "n" } },
                ['P'] = { function() refactoring.debug.printf({ below = true }) end, ' ', mode = { "n" } },
                ['v'] = { refactoring.debug.print_var, ' ', mode = { "x", "n" } },
                ['c'] = { refactoring.debug.cleanup, ' ', mode = { "n" } },
            },

            ["h"] = {
                ["a"] = { harpoonmark.add_file, 'Add file' },
                ["s"] = { harpoonui.toggle_quick_menu, 'Show files' },
                ["1"] = { function() harpoonui.nav_file(1) end, 'Open mark 1' },
                ["2"] = { function() harpoonui.nav_file(2) end, 'Open mark 2' },
                ["3"] = { function() harpoonui.nav_file(3) end, 'Open mark 3' },
                ["4"] = { function() harpoonui.nav_file(4) end, 'Open mark 4' },
                ["5"] = { function() harpoonui.nav_file(5) end, 'Open mark 5' },
                ["6"] = { function() harpoonui.nav_file(6) end, 'Open mark 6' },
                ["7"] = { function() harpoonui.nav_file(7) end, 'Open mark 7' },
                ["8"] = { function() harpoonui.nav_file(8) end, 'Open mark 8' },
                ["9"] = { function() harpoonui.nav_file(9) end, 'Open mark 9' },
            },
            ["t"] = {
                ['n'] = { ':tabedit ', 'Open file in new tab', silent = false, mode = { 'n' } },
                ['<Left>'] = { ':tabprev<CR>', 'Move to previous tab', silent = false, mode = { 'n' } },
                ['<Right>'] = { ':tabnext<CR>', 'Move to next tab', silent = false, mode = { 'n' } },
                ['q'] = { ':tabclose<CR>', 'Move to next tab', silent = false, mode = { 'n' } },
                ['t'] = { ':TodoTelescope<CR>', 'Show todo list', mode = { 'n' } },
            },
            ["c"] = {
                ['a'] = {
                    ['mir'] = { ":CellularAutomaton make_it_rain<CR>", 'Make it rain', silent = false, mode = { "n" } },
                    ['gol'] = { ":CellularAutomaton game_of_life<CR>", 'Game of life', silent = false, mode = { "n" } },
                    ['scr'] = { ":CellularAutomaton scramble<CR>", 'Scramble', silent = false, mode = { "n" } },
                    ['sli'] = { ":CellularAutomaton slide<CR>", 'Slide', silent = false, mode = { "n" } },
                },
                ['d'] = { match_path, "Change current Directory", mode = { 'n' } },
                ['o'] = { ':ColorizerToggle<CR>', 'Toggle colorizer', mode = { 'n', 'x' } }
            },
            ["y"] = { [["+y]], 'copy selection to system clipboard', mode = { 'n', 'x' } },
            ["Y"] = { [["+Y]], 'Copy current line to system clipboard', mode = { 'n' } },
            ["x"] = { "<cmd>!chmod +x %<CR>", 'Make current file executable', silent = true, mode = { "n" } },
            ['w'] = {
                [''] = { match_path, "Change current Directory", mode = { 'n' } },
                ['-'] = { [[ 10<C-w>- ]], "Decrease split's height", mode = { 'n' } },
                ['='] = { [[ 10<C-w>+ ]], "Increase split's height", mode = { 'n' } },
                [','] = { [[ 20<C-w>< ]], "Decrease split's width", mode = { 'n' } },
                ['.'] = { [[ 20<C-w>> ]], "Increase split's width", mode = { 'n' } },
            },
            ['/'] = { ':CommentToggle<CR>', 'Comment selection', mode = { 'n', 'x' } }
        },

        [";"] = { ts_repeat_move.repeat_last_move_next, 'next match', mode = { "n", "x", "o" } },
        [","] = { ts_repeat_move.repeat_last_move_previous, 'previous match', mode = { "n", "x", "o" } },

        ["f"] = { ts_repeat_move.builtin_f, ' ', mode = { "n", "x", "o" } },
        ["F"] = { ts_repeat_move.builtin_F, ' ', mode = { "n", "x", "o" } },
        ["t"] = { ts_repeat_move.builtin_t, ' ', mode = { "n", "x", "o" } },
        ["T"] = { ts_repeat_move.builtin_T, ' ', mode = { "n", "x", "o" } },
    })
else
    vim.keymap.set('n', '<leader>', function() vim.fn.VSCodeNotify('whichkey.show') end,
        { noremap = true, silent = true })
end
