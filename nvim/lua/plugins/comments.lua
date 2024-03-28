return {
    "echasnovski/mini.comment",
    lazy = true,
    keys = {"<Space>/"},
    config = function()
        require("mini.comment").setup({
            padding = true,
            mappings = {
                comment = "<Space>/",
                comment_line = "<Space>/",
                comment_visual = "<Space>/",
                textobject = "gc"
            }
        })
    end
}
