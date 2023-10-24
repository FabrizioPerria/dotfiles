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

local function replace()
    local keys
    local mode= vim.api.nvim_get_mode()['mode']
    if mode == 'n' then
        keys = vim.api.nvim_replace_termcodes(':%s///gI<Left><Left><Left><Left>', false, false, true)
    else
        keys = vim.api.nvim_replace_termcodes(':s///gI<Left><Left><Left><Left>', false, false, true)
    end
    vim.api.nvim_feedkeys(keys, mode, {})
end

local wk = require("which-key")
local telescope = require('telescope')
local projects = telescope.extensions.project.project
local undo = telescope.extensions.undo.undo
local refactoring = require('refactoring')
local diffview = require('diffview.actions')
local tbi = require("telescope.builtin")
local harpoonui = require('harpoon.ui')
local harpoonmark = require('harpoon.mark')

wk.register({
    ['<leader>'] = {
        ["f"] = {
            ["name"] = '+file',
            [""] = { vim.lsp.buf.format, 'Format file', mode = { 'n' } },
            ['b'] = { tbi.buffers, 'Show buffers', silent = false, mode = { 'n' } },
            ['f'] = { tbi.find_files, 'Fuzzy file search', mode = { 'n' } },
            ['g'] = { tbi.git_files, 'Fuzzy file search in git repository', mode = { 'n' } },
            ['s'] = { function() tbi.live_grep({ search_dir = '%:p:h' }) end, 'Grep search', mode = { 'n' } },
            ['v'] = { ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>',
                'Show file browser', silent = false, mode = { 'n' } },
            ['k'] = { tbi.keymaps, 'Show keymaps', mode = { 'n' } },
            ['h'] = { tbi.help_tags, 'Find man pages for vim commands', mode = { 'n' } },
            ['p'] = { projects, 'Show marked projects', silent = false, mode = { 'n' } },
        },
        ['u'] = { undo, "Undo menu", mode = { 'n', 'x' } },

        ["g"] = {
            ["name"] = '+git',
            [""] = { ":vertical Git | vertical resize 60<CR>", ' ', silent = false, mode = { "n" } },
            ["co"] = { ':Git commit -m ""<Left>', ' ', mode = { "n" }, silent = false },
            ["g"] = { ":Git pull --rebase", ' ', silent = false, mode = { "n" } },
            ["p"] = { ":Git push -u origin ", ' ', silent = false, mode = { "n" } },
            ["m"] = { ":Git merge ", ' ', silent = false, mode = { "n" } },
            ["L"] = { ":vertical Git log | vertical resize 100<CR>", ' ', silent = false, mode = { "n" } },
            ["t"] = { ":GV<CR>", ' ', silent = false, mode = { "n" } },
            ["a"] = { ":Gwrite<CR>", ' ', silent = false, mode = { "n" } },
            ["-"] = { ":Gread<CR>", ' ', silent = false, mode = { "n" } },
            ["ch"] = { ":Git checkout ", ' ', silent = false, mode = { "n" } },
            ["B"] = { ":Telescope git_branches<CR>", ' ', silent = false, mode = { "n" } },
            ["s"] = { ":Telescope git_stash<CR>", ' ', silent = false, mode = { "n" } },
            ["sa"] = { ":Git stash<CR>", ' ', silent = false, mode = { "n" } },
            ["sp"] = { ":Git stash pop<CR>", ' ', silent = false, mode = { "n" } },
            ["f"] = { ":Telescope git_files<CR>", ' ', silent = false, mode = { "n" } },
            ["l"] = { ":Telescope git_commits<CR>", ' ', silent = false, mode = { "n" } },
            ['d'] = { DiffViewToggle, ' ', mode = { "n" } },
            ['<Left>'] = { diffview.diffget("ours"), ' ', mode = { 'n', 'x' } },
            ['<Right>'] = { diffview.diffget("theirs"), ' ', mode = { 'n', 'x' } },
            ['<Down>'] = { diffview.diffput("local"), ' ', mode = { 'n', 'x' } },
            ['<Up>'] = { '<C-j>u', ' ', mode = { 'n', 'x' } },
            ["b"] = { ':GitBlameToggle<CR>', '', silent = false, mode = { 'n', 'x' } }
        },

        ["r"] = {
            ["name"] = '+refactoring',
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
            ["name"] = '+print',
            ['p'] = { function() refactoring.debug.printf({ below = false }) end, ' ', mode = { "n" } },
            ['P'] = { function() refactoring.debug.printf({ below = true }) end, ' ', mode = { "n" } },
            ['v'] = { refactoring.debug.print_var, ' ', mode = { "x", "n" } },
            ['c'] = { refactoring.debug.cleanup, ' ', mode = { "n" } },
        },

        ["h"] = {
            ["name"] = "+harpoon",
            ["a"]    = { harpoonmark.add_file, 'Add file' },
            ["s"]    = { harpoonui.toggle_quick_menu, 'Show files' },
            ["1"]    = { function() harpoonui.nav_file(1) end, 'Open mark 1' },
            ["2"]    = { function() harpoonui.nav_file(2) end, 'Open mark 2' },
            ["3"]    = { function() harpoonui.nav_file(3) end, 'Open mark 3' },
            ["4"]    = { function() harpoonui.nav_file(4) end, 'Open mark 4' },
            ["5"]    = { function() harpoonui.nav_file(1) end, 'Open mark 5' },
            ["6"]    = { function() harpoonui.nav_file(2) end, 'Open mark 6' },
            ["7"]    = { function() harpoonui.nav_file(3) end, 'Open mark 7' },
            ["8"]    = { function() harpoonui.nav_file(4) end, 'Open mark 8' },
            ["9"]    = { function() harpoonui.nav_file(4) end, 'Open mark 9' },
        },
        ["t"] = {
            ["name"] = '+tabline',
            ['n'] = { ':tabedit ', 'Open file in new tab', silent = false, mode = { 'n' } },
            ['<Left>'] = { ':tabprev<CR>', 'Move to previous tab', silent = false, mode = { 'n' } },
            ['<Right>'] = { ':tabnext<CR>', 'Move to next tab', silent = false, mode = { 'n' } },
            ['q'] = { ':tabclose<CR>', 'Move to next tab', silent = false, mode = { 'n' } },
        },
        ["c"] = {
            ['a'] = {
                ['mir'] = { ":CellularAutomaton make_it_rain<CR>", 'Make it rain', silent = false, mode = { "n" } },
                ['gol'] = { ":CellularAutomaton game_of_life<CR>", 'Game of life', silent = false, mode = { "n" } },
                ['scr'] = { ":CellularAutomaton scramble<CR>", 'Scramble', silent = false, mode = { "n" } },
                ['sli'] = { ":CellularAutomaton slide<CR>", 'Slide', silent = false, mode = { "n" } },
            },
            ['d'] = { match_path, "Change current Directory", mode = { 'n' } }
        },
        ["y"] = { [["+y]], 'copy selection to system clipboard', mode = { 'n', 'x' } },
        ["Y"] = { [["+Y]], 'Copy current line to system clipboard', mode = { 'n' } },
        ["s"] = { replace, 'Replace in file', mode = { "n", 'x' }, silent = false },
        ["x"] = { "<cmd>!chmod +x %<CR>", 'Make current file executable', silent = true, mode = { "n" } },
        ['w'] = { match_path, "Change current Directory", mode = { 'n' } },

    }
})
