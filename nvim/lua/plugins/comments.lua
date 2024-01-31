return {
  "echasnovski/mini.comment",
  lazy = false,
  config = function()
    require("mini.comment").setup({
      -- prefix = "//",
      padding = true,
      mappings = {
        comment = "<Space>/",
        comment_line = "<Space>/",
        comment_visual = "<Space>/",
        textobject = "gc",
      },
    })
  end,
}
