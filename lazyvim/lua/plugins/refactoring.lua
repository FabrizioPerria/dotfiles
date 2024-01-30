return {
  "ThePrimeagen/refactoring.nvim",
  event = "BufRead",
  requires = {
    { "nvim-lua/plenary.nvim" },
    { "nvim-treesitter/nvim-treesitter" },
  },
  config = function()
    require("refactoring").setup({
      prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
      -- prompt for function parameters
      prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
        java = true,
      },
    })
  end,
  keys = {
    {
      "<leader>r",
      function()
        require("refactoring").select_refactor()
      end,
      "Select refactor type",
      mode = { "n", "x" },
    },
    { "<leader>re", ":Refactor extract ", "Extract Selection", silent = false, mode = { "x" } },
    { "<leader>rf", ":Refactor extract_to_file ", "Extract selection to file", silent = false, mode = { "x" } },
    { "<leader>rF", ":Refactor inline_func", "Inline Function", silent = false, mode = { "n", "x" } },
    { "<leader>rv", ":Refactor extract_var ", "Extract selected variable", silent = false, mode = { "x" } },
    { "<leader>rV", ":Refactor inline_var", "Inline variable", silent = false, mode = { "n", "x" } },
    { "<leader>rb", ":Refactor extract_block", "Extract block", silent = false, mode = { "x" } },
    { "<leader>rbf", ":Refactor extract_block_to_file", "Extract block to file", silent = false, mode = { "x" } },

    {
      "<leader>pp",
      function()
        require("refactoring").debug.printf({ below = false })
      end,
      " ",
      mode = { "n" },
    },
    {
      "<leader>pP",
      function()
        require("refactoring ").debug.printf({ below = true })
      end,
      " ",
      mode = { "n" },
    },
    {
      "<leader>pv",
      function()
        require("refactoring ").debug.print_var()
      end,
      " ",
      mode = { "x", "n" },
    },
    {
      "<leader>pc",
      function()
        require("refactoring ").debug.cleanup()
      end,
      " ",
      mode = { "n" },
    },
  },
}
