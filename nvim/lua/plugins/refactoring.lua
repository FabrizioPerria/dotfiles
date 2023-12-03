return {
  "theprimeagen/refactoring.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>r",
      "<cmd>lua require('refactoring').select_refactor<cr>",
      desc = "Select refactor type",
      mode = { "n", "x" },
    },
    {
      "<leader>re",
      ":Refactor extract ",
      desc = "Extract Selection",
      silent = false,
      mode = { "x" },
    },
    {
      "<leader>rf",
      ":Refactor extract_to_file ",
      desc = "Extract selection to file",
      silent = false,
      mode = { "x" },
    },
    {
      "<leader>rF",
      ":Refactor inline_func",
      desc = "Inline Function",
      silent = false,
      mode = { "n", "x" },
    },
    {
      "<leader>rv",
      ":Refactor extract_var ",
      desc = "Extract selected variable",
      silent = false,
      mode = { "x" },
    },
    {
      "<leader>rV",
      ":Refactor inline_var",
      desc = "Inline variable",
      silent = false,
      mode = { "n", "x" },
    },
    {
      "<leader>rb",
      ":Refactor extract_block",
      desc = "Extract block",
      silent = false,
      mode = { "x" },
    },
    {
      "<leader>rbf",
      ":Refactor extract_block_to_file",
      desc = "Extract block to file",
      silent = false,
      mode = { "x" },
    },
    {
      "<leader>pp",
      function()
        require("refactoring").debug.printf({ below = false })
      end,
      desc = " ",
      mode = { "n" },
    },
    {
      "<leader>pP",
      function()
        require("refactoring").debug.printf({ below = true })
      end,
      desc = " ",
      mode = { "n" },
    },
    {
      "<leader>pv",
      "<cmd>lua require('refactoring').debug.print_var<cr>",
      desc = " ",
      mode = { "x", "n" },
    },
    {
      "<leader>pc",
      "<cmd>lua require('refactoring').debug.cleanup<cr>",
      desc = " ",
      mode = { "n" },
    },
  },
}
