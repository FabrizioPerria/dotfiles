require("diffview").setup({
    view = {
        merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = false,
        },
    },
})

vim.keymap.set("n", "<leader>gd", function()
    if next(require('diffview.lib').views) == nil then
        vim.cmd('DiffviewOpen')
    else
        vim.cmd('DiffviewClose')
    end
end)

local actions = require("diffview.actions")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Left>", actions.diffget("ours"))  --"print<leader>co")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Right>", actions.diffget("theirs")) -- "<leader>ct")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Down>", actions.diffput("local")) -- "<leader>ct")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Up>", '<C-j>u')                   -- "<leader>ct")
