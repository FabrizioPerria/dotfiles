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
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Left>", actions.diffget("ours"))  --"<leader>co")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Right>", actions.diffget("theirs")) -- "<leader>ct")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Down>", actions.diffput("local")) -- "<leader>ct")
vim.keymap.set({ 'n', 'v', 'x' }, "<leader>g<Up>", '<C-j>u')                   -- "<leader>ct")
-- { "n", "<leader>co",  actions.conflict_choose("ours"),        { desc = "Choose the OURS version of a conflict" } },
-- { "n", "<leader>ct",  actions.conflict_choose("theirs"),      { desc = "Choose the THEIRS version of a conflict" } },
-- { "n", "<leader>cb",  actions.conflict_choose("base"),        { desc = "Choose the BASE version of a conflict" } },
-- { "n", "<leader>ca",  actions.conflict_choose("all"),         { desc = "Choose all the versions of a conflict" } },
-- { "n", "dx",          actions.conflict_choose("none"),        { desc = "Delete the conflict region" } },

-- vim.api.nvim_set_hl(0, "DiffAdd", { fg='#50FA7B' })
-- vim.fn.sign_define("DiffAdd", { text = '+', texthl = "green", linehl = "diffAdd", numhl = "" })

-- vim.api.nvim_set_hl(0, "DiffDelete", { fg='#FA5057' })
-- vim.fn.sign_define("DiffDelete", { text = '-', texthl = "red", linehl = "diffText", numhl = "" })

-- vim.api.nvim_set_hl(0, "DiffChange", { fg='#1010FA' })
-- vim.fn.sign_define("DiffChange", { text = '~', texthl = "orange", linehl = "diffChange", numhl = "" })

-- vim.api.nvim_set_hl(0, "DiffText", { fg='#105057' })
-- vim.fn.sign_define("DiffText", { text = '-', texthl = "blue", linehl = "diffText", numhl = "" })
