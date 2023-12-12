local wk = require("which-key")
vim.g.mapleader = " "
vim.keymap.set('n', 'J', 'mzJ`z', { noremap = true })

if not vim.g.vscode then
    vim.keymap.set('n', '<leader>s', ':%s///gI<Left><Left><Left><Left>')
    vim.keymap.set('x', '<leader>s', ':s///gI<Left><Left><Left><Left>')
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
    local refactoring    = require('refactoring')
    local diffview       = require('diffview.actions')
    local harpoon        = require('harpoon')
    local dap            = require('dap')
    local tbi            = require("telescope.builtin")

    wk.register({
        ["<C-s>"] = { vim.lsp.buf.signature_help, "Signature help", mode = { 'i', 'n' } },
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
                ['v'] = {
                    ':Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>',
                    'Show file browser',
                    silent = false,
                    mode = { 'n' }
                },
                ['k'] = { tbi.keymaps, 'Show keymaps', mode = { 'n' } },
                ['h'] = { tbi.help_tags, 'Find man pages for vim commands', mode = { 'n' } },
                ['p'] = { ':Telescope project<CR>', 'Show marked projects', silent = false, mode = { 'n' } },
            },

            ['u'] = { ':Telescope undo<CR>', "Undo menu", mode = { 'n', 'x' } },

            ["g"] = {
                -- [""] = { tbi.git_status, ' ', silent = false, mode = { "n" } },
                [""] = { ":LazyGit<CR>", ' ', silent = false, mode = { "n" } },
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
                ["a"] = { function() harpoon:list():append() end, 'Add file' },
                ["s"] = { function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, 'Show files' },
                ["1"] = { function() harpoon:list():select(1) end, 'Open mark 1' },
                ["2"] = { function() harpoon:list():select(2) end, 'Open mark 2' },
                ["3"] = { function() harpoon:list():select(3) end, 'Open mark 3' },
                ["4"] = { function() harpoon:list():select(4) end, 'Open mark 4' },
                ["5"] = { function() harpoon:list():select(5) end, 'Open mark 5' },
                ["6"] = { function() harpoon:list():select(6) end, 'Open mark 6' },
                ["7"] = { function() harpoon:list():select(7) end, 'Open mark 7' },
                ["8"] = { function() harpoon:list():select(8) end, 'Open mark 8' },
                ["9"] = { function() harpoon:list():select(9) end, 'Open mark 9' },
            },
            ["t"] = {
                ['<Left>'] = { ':tabprev<CR>', 'Move to previous tab', silent = false, mode = { 'n' } },
                ['<Right>'] = { ':tabnext<CR>', 'Move to next tab', silent = false, mode = { 'n' } },
                ['q'] = { ':tabclose<CR>', 'Move to next tab', silent = false, mode = { 'n' } },
                ['t'] = { ':TodoTelescope<CR>', 'Show todo list', mode = { 'n' } },
                ['a'] = { "<cmd>lua require('neotest').run.attach()<cr>", "Attach" },
                ['f'] = { "<cmd>lua require('neotest').run.run(vim.fn.expand('%'))<cr>", "Run File" },
                ['F'] = { "<cmd>lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>", "Debug File" },
                ['l'] = { "<cmd>lua require('neotest').run.run_last()<cr>", "Run Last" },
                ['L'] = { "<cmd>lua require('neotest').run.run_last({ strategy = 'dap' })<cr>", "Debug Last" },
                ['n'] = { "<cmd>lua require('neotest').run.run()<cr>", "Run Nearest" },
                ['N'] = { "<cmd>lua require('neotest').run.run({strategy = 'dap'})<cr>", "Debug Nearest" },
                ['o'] = { "<cmd>lua require('neotest').output.open({ enter = true })<cr>", "Output" },
                ['S'] = { "<cmd>lua require('neotest').run.stop()<cr>", "Stop" },
                ['s'] = { "<cmd>lua require('neotest').summary.toggle()<cr>", "Summary" },
                -- ['p'] = { "<Plug>PlenaryTestFile", "PlenaryTestFile" },
                ['v'] = { "<cmd>TestVisit<cr>", "Visit" },
                ['w'] = { "<cmd>lua require('neotest').watch.toggle(vim.fn.expand('%'))<cr>", "Watch" },
                ['x'] = { "<cmd>TestSuite<cr>", "Suite" },
            },
            ["c"] = {
                ['a'] = {
                    ['mir'] = { ":CellularAutomaton make_it_rain<CR>", 'Make it rain', silent = false, mode = { "n" } },
                    ['gol'] = { ":CellularAutomaton game_of_life<CR>", 'Game of life', silent = false, mode = { "n" } },
                    ['scr'] = { ":CellularAutomaton scramble<CR>", 'Scramble', silent = false, mode = { "n" } },
                    ['sli'] = { ":CellularAutomaton slide<CR>", 'Slide', silent = false, mode = { "n" } },
                },
                ['d'] = { match_path, "Change current Directory", mode = { 'n' } },
                ['o'] = { ':ColorizerToggle<CR>', 'Toggle colorizer', mode = { 'n', 'x' } },
                ['B'] = { ':CodeBox<CR>', '', mode = { 'x' } },
                ['b'] = { ':CodeUnbox<CR>', '', mode = { 'n' } },
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
            ["="] = { function()
                local buf = vim.api.nvim_get_current_buf()
                local row = vim.api.nvim_win_get_cursor(0)[1]
                local sep =
                "===================================================================================================="
                vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
                require("mini.comment").toggle_lines(row + 1, row + 1)
                vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
            end, "Insert Separator" },
            --['/'] = { ':CommentToggle<CR>', 'Comment selection', mode = { 'n', 'x' } },
            ['.'] = { require("actions-preview").code_actions, 'Code Actions', mode = { 'n' } },
            [";"] = { vim.lsp.buf.hover, 'Hover', mode = { "n", "x" } },
            ['v'] = {
                ['S'] = {
                    function()
                        tbi.lsp_dynamic_workspace_symbols({
                            symbol_width = 60,
                            symbol_type_width = 30,
                            fname_width = 50
                        })
                    end,
                    "Show current Workspace Symbols",
                    mode = { 'n' }
                },
                ['s'] = {
                    function()
                        tbi.lsp_document_symbols({
                            symbol_width = 60,
                            symbol_type_width = 30,
                            fname_width = 80
                        })
                    end,
                    "Show symbols in document",
                    mode = { 'n' }
                },
                ['r'] = {
                    function() tbi.lsp_references({ fname_width = 80 }) end,
                    "Show references",
                    mode = {
                        'n' }
                },
                ['d'] = {
                    function() tbi.lsp_definitions({ jump_type = 'vsplit', fname_width = 80 }) end,
                    "Go to definition",
                    mode = { 'n' }
                },
                ['t'] = {
                    function() tbi.lsp_type_definitions({ fname_width = 80 }) end,
                    "Go to type definition",
                    mode = {
                        'n' }
                },
                ['i'] = {
                    function() tbi.lsp_implementations({ fname_width = 80 }) end,
                    "Go to implementation",
                    mode = {
                        'n' }
                },
                ['rn'] = { vim.lsp.buf.rename, "rename symbol", mode = { 'n' } },
                ['e'] = { tbi.diagnostics, "Show diagnostics", mode = { 'n' } },
            },
            ['dd'] = {
                function()
                    if vim.diagnostic.is_disabled() then
                        vim.diagnostic.enable()
                    else
                        vim.diagnostic
                            .disable()
                    end
                end,
                'Toggle diagnostics',
                mode = { 'n', 'x' }
            },
        },

        ["[d"] = { vim.diagnostic.goto_next, 'Next diagnostic', mode = { 'n' } },
        ["]d"] = { vim.diagnostic.goto_prev, 'Prev diagnostic', mode = { 'n' } },

        [";"] = { ts_repeat_move.repeat_last_move_next, 'next match', mode = { "n", "x", "o" } },
        [","] = { ts_repeat_move.repeat_last_move_previous, 'previous match', mode = { "n", "x", "o" } },

        ["f"] = { ts_repeat_move.builtin_f, ' ', mode = { "n", "x", "o" } },
        ["F"] = { ts_repeat_move.builtin_F, ' ', mode = { "n", "x", "o" } },
        ["t"] = { ts_repeat_move.builtin_t, ' ', mode = { "n", "x", "o" } },
        ["T"] = { ts_repeat_move.builtin_T, ' ', mode = { "n", "x", "o" } },
    })
else
    local vscode = require("vscode-neovim")
    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    wk.register({
        ['J'] = { ":m \'>+1<CR>gv=gv", 'Move selected block up', mode = { 'x' } },
        ['K'] = { ":m \'<-2<CR>gv=gv", 'Move selected block down', mode = { 'x' } },
        ["Y"] = { 'yy', 'Alternative copy full line', mode = { 'n' } },

        ["<C-d>"] = { "<C-d>zz", 'Scroll down and center', mode = { 'n', 'x' } },
        ["<C-u>"] = { "<C-u>zz", 'Scroll up and center', mode = { 'n', 'x' } },

        ['<leader>'] = {
            ['s'] = { function() vscode.call("vim-search-and-replace.start") end, 'Find in files', mode = { 'n', 'x' } },
            ["f"] = {
                [""] = { function() vscode.call("editor.action.formatDocument") end, 'Format file', mode = { 'n' } },
                ['f'] = { function() vscode.call("workbench.action.quickOpen") end, 'Fuzzy file search', mode = { 'n' } },
                ['b'] = {
                    function() vscode.call("workbench.action.showAllEditors") end,
                    'Show buffers',
                    silent = false,
                    mode = {
                        'n' }
                },
                ['g'] = {
                    function() vscode.call("workbench.view.scm") end,
                    'Fuzzy file search in git repository',
                    mode = {
                        'n' }
                },
                ['s'] = { function() vscode.call("livegrep.search") end, 'Grep search', mode = { 'n' } },
                ['v'] = {
                    function() vscode.call("workbench.explorer.fileView.focus") end,
                    'Show file browser',
                    silent = false,
                    mode = {
                        'n' }
                },
                ['p'] = {
                    [''] = {
                        function() vscode.call("projectManager.listFavoriteProjects#sideBarFavorites") end,
                        'Show marked projects',
                        silent = false,
                        mode = {
                            'n' }
                    },
                    ['a'] = {
                        function() vscode.call("projectManager.addToFavorites") end,
                        "Add to projects",
                        mode = {
                            'n' }
                    }
                }
            },

            ["g"] = {
                [""] = { function() vscode.call("workbench.view.scm") end, ' ', silent = false, mode = { "n" } },
                ["co"] = { function() vscode.call("git.commit") end, ' ', mode = { "n" }, silent = false },
                ["g"] = { function() vscode.call("git.pullRebase") end, ' ', silent = false, mode = { "n" } },
                ["p"] = { function() vscode.call("git.push") end, ' ', silent = false, mode = { "n" } },
                ["m"] = { function() vscode.call("git.merge") end, ' ', silent = false, mode = { "n" } },
                ["t"] = { function() vscode.call("git-graph.view") end, ' ', silent = false, mode = { "n" } },
                ["ch"] = { function() vscode.call("git.checkout") end, ' ', silent = false, mode = { "n" } },
                ["sa"] = { function() vscode.call("git.stash") end, ' ', silent = false, mode = { "n" } },
                ["sp"] = { function() vscode.call("git.stashPop") end, ' ', silent = false, mode = { "n" } },
                ["l"] = { function() vscode.call("git.viewHistory") end, ' ', silent = false, mode = { "n" } },
                ["b"] = { function() vscode.call("gitlens.toggleLineBlame") end, '', silent = false, mode = { 'n', 'x' } }
            },

            ["h"] = {
                ["a"] = { function() vscode.call("vscode-harpoon.addEditor") end, 'Add file' },
                ["s"] = { function() vscode.call("vscode-harpoon.editorQuickPick") end, 'Show files' },
                ["1"] = { function() vscode.call("vscode-harpoon.gotoEditor1") end, 'Open mark 1' },
                ["2"] = { function() vscode.call("vscode-harpoon.gotoEditor2") end, 'Open mark 2' },
                ["3"] = { function() vscode.call("vscode-harpoon.gotoEditor3") end, 'Open mark 3' },
                ["4"] = { function() vscode.call("vscode-harpoon.gotoEditor4") end, 'Open mark 4' },
                ["5"] = { function() vscode.call("vscode-harpoon.gotoEditor5") end, 'Open mark 5' },
                ["6"] = { function() vscode.call("vscode-harpoon.gotoEditor6") end, 'Open mark 6' },
                ["7"] = { function() vscode.call("vscode-harpoon.gotoEditor7") end, 'Open mark 7' },
                ["8"] = { function() vscode.call("vscode-harpoon.gotoEditor8") end, 'Open mark 8' },
                ["9"] = { function() vscode.call("vscode-harpoon.gotoEditor9") end, 'Open mark 9' },
            },

            ["t"] = {
                [''] = { function() vscode.call("workbench.action.terminal.focus") end, 'Enable Terminal', mode = { 'n' } },
                ['t'] = { function() vscode.call("todohighlight.listAnnotations") end, 'Show todo list', mode = { 'n' } },
            },
            ["v"] = {
                ["s"] = { function() vscode.call("workbench.action.gotoSymbol") end, '', mode = { 'n' } },
                ["r"] = { function() vscode.call("editor.action.goToReferences") end, '', mode = { 'n' } },
                ["d"] = { function() vscode.call("editor.action.goToDeclaration") end, '', mode = { 'n' } },
                ["i"] = { function() vscode.call("editor.action.goToImplementation") end, '', mode = { 'n' } },
                [";"] = { function() vscode.call("editor.action.showHover") end, '', mode = { 'n' } },
                ["rn"] = { function() vscode.call("editor.action.rename") end, '', mode = { 'n' } },
            },
            ["y"] = { [["+y]], 'copy selection to system clipboard', mode = { 'n', 'x' } },
            ["Y"] = { [["+Y]], 'Copy current line to system clipboard', mode = { 'n' } },
            ['/'] = { function() vscode.call("editor.action.commentLine") end, 'Comment selection', mode = { 'n', 'x' } },
            ['='] = {
                function()
                    local buf = vim.api.nvim_get_current_buf()
                    local row = vim.api.nvim_win_get_cursor(0)[1]
                    local sep =
                    "===================================================================================================="
                    vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
                    vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
                    vscode.action('editor.action.commentLine')
                end,
                'Comment selection',
                mode = { 'n' }
            },
        },

        [";"] = { ts_repeat_move.repeat_last_move_next, 'next match', mode = { "n", "x", "o" } },
        [","] = { ts_repeat_move.repeat_last_move_previous, 'previous match', mode = { "n", "x", "o" } },

        ["f"] = { ts_repeat_move.builtin_f, ' ', mode = { "n", "x", "o" } },
        ["F"] = { ts_repeat_move.builtin_F, ' ', mode = { "n", "x", "o" } },
        ["t"] = { ts_repeat_move.builtin_t, ' ', mode = { "n", "x", "o" } },
        ["T"] = { ts_repeat_move.builtin_T, ' ', mode = { "n", "x", "o" } },
    })
end
