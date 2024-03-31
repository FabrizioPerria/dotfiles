local function DiffViewToggle()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end

return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup({
                signs = {
                    add          = { text = '+' },
                    change       = { text = '~' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '-' },
                    untracked    = { text = '►' },
                },
            })
        end,
    },
    {
        "FabijanZulj/blame.nvim",
        keys = {
            { "<leader>gB", "<cmd>ToggleBlame virtual<CR>", "toggle git blame - Full file" },
        },
    },
    {
        "f-person/git-blame.nvim",
        config = function()
            vim.g.gitblame_enabled = false
            vim.g.gitblame_virtual_text_column = 120
            vim.g.gitblame_highlight_group = "Question"
            vim.g.gitblame_message_when_not_committed = 'NOT COMMITTED YET'
            require("gitblame").setup({
                enabled = false,
                message_template = "[<sha>] <summary> • <author> • <date>",
            })
        end,
        keys = {
            { "<leader>gb", "<cmd>GitBlameToggle<CR>", "toggle git blame - Single Line" },
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
            { "<leader>gd",        function() DiffViewToggle() end,                    "toggle diff" },
            { "<leader>gd<Left>",  "<cmd>lua require('diffview').diffget('base')<CR>", "" },
            { "<leader>gd<Right>", "<cmd>lua require('diffview').diffget('mine')<CR>", "" },
            { "<leader>gd<Down>",  "<cmd>lua require('diffview').diffput('mine')<CR>", "" },
            { "<leader>gd<Up>",    "<cmd>lua require('diffview').diffput('base')<CR>", "" },
        },
    },
}
