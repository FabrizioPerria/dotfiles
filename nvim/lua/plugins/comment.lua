return {
  "echasnovski/mini.comment",
  keys = {
    {
      "<leader>=",
      function()
        local buf = vim.api.nvim_get_current_buf()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local sep =
          "===================================================================================================="
        vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
        -- vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
        require("mini.comment").toggle_lines(row + 1, row + 1)
        vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
      end,
      desc = "Insert Separator",
      mode = { "n", "x" },
    },
  },
  opts = {
    mappings = {
      comment = "<leader>/",
      comment_line = "<leader>/",
      comment_visual = "<leader>/",
      textobject = "gc",
    },
  },
}
