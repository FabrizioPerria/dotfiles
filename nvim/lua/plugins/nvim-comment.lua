return {
  "terrortylor/nvim-comment",
  keys = {
    { "<leader>/", "<cmd>CommentToggle<cr>", desc = "Comment selection", mode = { "n", "x" } },
    {
      "<leader=",
      function()
        local buf = vim.api.nvim_get_current_buf()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local sep =
          "===================================================================================================="
        vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
        vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        vim.api.nvim_command("CommentToggle")
      end,
      desc = "Insert Separator",
      mode = { "n", "x" },
    },
  },
}
