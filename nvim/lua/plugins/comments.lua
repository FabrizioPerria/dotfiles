return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        config = function()
            require('ts_context_commentstring').setup {}
            vim.g.skip_ts_context_commentstring_module = true
        end,
    },
    {
        "echasnovski/mini.comment",
        -- lazy = true,
        -- keys = {
        --     {"<leader>/" },
        -- },
        config = function()
            require("mini.comment").setup({
                padding = true,
                mappings = {
                    comment = "<leader>/",
                    comment_line = "<leader>/",
                    comment_visual = "<leader>/",
                    textobject = "gc",
                },
            })
        end,
    },
}
