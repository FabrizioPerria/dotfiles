local function DiffViewToggle()
    if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
    else
        vim.cmd("DiffviewClose")
    end
end

return {
    {
        "tpope/vim-fugitive",
        cmd = "Git",
        keys = {
            { "<leader>Gsa", "<cmd>Git stash<CR>", "git stash" },
            { "<leader>Gsp", "<cmd>Git stash pop<CR>", "git stash pop" },
            { "<leader>Gco", ':Git commit -S -m ""<Left>', "git commit" },
            { "<leader>Gpr", ":Git pull --rebase ", "git pull (rebase)" },
            { "<leader>GP", ":Git push origin ", "git push" },
            { "<leader>Gm", ":Git merge ", "git merge" },
            { "<leader>GL", ":vert Git log --show-signature | vertical resize 100<CR>", "git log" },
            { "<leader>Gch", ":Git checkout ", "git checkout" },
            { "<leader>Ga", "<cmd>Gwrite<CR>", "git add" },
            { "<leader>G-", "<cmd>Gread<CR>", "git read" },
        },
    },
    {
        "junegunn/gv.vim",
        keys = {
            { "<leader>gv", "<cmd>GV<CR>", "git log (graph)" },
        },
    },
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
