return {
  "echasnovski/mini.comment",
  opts = {
    mappings = {
      comment = "<leader>/",
      comment_line = "<leader>/",
      comment_visual = "<leader>/",
      textobject = "gc",
    },
  },
}
-- return {
--   "terrortylor/nvim-comment",
--   cmd = "CommentToggle",
--   keys = {
--     { "<leader>/", ":CommentToggle<cr>", desc = "Comment selection", mode = { "n", "x" } },
--     {
--       "<leader>=",
--       function()
--         local buf = vim.api.nvim_get_current_buf()
--         local row = vim.api.nvim_win_get_cursor(0)[1]
--         local sep =
--           "===================================================================================================="
--         vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
--         vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
--         vim.api.nvim_command("CommentToggle")
--       end,
--       desc = "Insert Separator",
--       mode = { "n", "x" },
--     },
--   },
--   opts = {
--     marker_padding = true,
--     comment_empty = false,
--     comment_empty_trim_whitespace = true,
--     comment_chunk_text_object = "ic",
--   },
--   config = function(_, opts)
--     require("nvim_comment").setup(opts)
--   end,
-- }
