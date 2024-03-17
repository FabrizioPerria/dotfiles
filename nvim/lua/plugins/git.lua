local function DiffViewToggle()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end

return {
    {
        "f-person/git-blame.nvim",
        config = function()
            vim.g.gitblame_enabled = false
            require("gitblame").setup({
                enabled = false,
                message_template = "[<sha>] <summary> • <author> • <date>",
            })
        end,
        keys = {
            { "<leader>gb", "<cmd>GitBlameToggle<CR>", "toggle git blame" },
        },
    },
    {
        "sindrets/diffview.nvim",
        config = function()
            require("diffview").setup({
                view = {
                    merge_tool = {
                        layout = "diff3_mixed",
                        disable_diagnostics = false,
                    },
                },
            })
        end,
        keys = {
            { "<leader>gd", "<cmd>DiffviewToggle<CR>", "toggle diff" },
            { "<leader>gd<Left>", "<cmd>lua require('diffview').diffget('base')<CR>", "" },
            { "<leader>gd<Right>", "<cmd>lua require('diffview').diffget('mine')<CR>", "" },
            { "<leader>gd<Down>", "<cmd>lua require('diffview').diffput('mine')<CR>", "" },
            { "<leader>gd<Up>", "<cmd>lua require('diffview').diffput('base')<CR>", "" },
        },
    },
}
