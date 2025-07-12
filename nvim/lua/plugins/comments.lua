return {
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        lazy = true,
        opts = {},
        init = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
    },
    {
        "echasnovski/mini.comment",
        lazy = true,
        keys = {
            { "<leader>/", mode = { "n", "v" } },
        },
        opts = {
            padding = true,
            mappings = {
                comment = "<leader>/",
                comment_line = "<leader>/",
                comment_visual = "<leader>/",
                textobject = "gc",
            },
        },
    },
}
