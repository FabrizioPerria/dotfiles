-- require('project_nvim').setup({
--     manual_mode=false,
--     patterns = {
--         ".git/$",
--         "*.sln",
--         "Makefile",
--         "!.git/worktrees",
--         "!build"
--     },
--     detection_methods = {
--         "patterns",
--         "lsp"
--     },
--     show_hidden=true
-- })

-- vim.keymap.set('n', '<leader>fp', ":Telescope projects<CR>", {desc='Show nvim projects'})
--
vim.keymap.set( 'n', '<leader>fp', ":lua require'telescope'.extensions.project.project{}<CR>", {noremap = true, silent = true})
