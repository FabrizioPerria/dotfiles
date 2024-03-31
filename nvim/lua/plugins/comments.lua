return {
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
                textobject = "gc"
            }
        })
    end
}
