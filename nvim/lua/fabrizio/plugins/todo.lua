return {
    "folke/todo-comments.nvim",
    enabled = vim.g.vscode == 0,
    config = function() require('todo-comments').setup() end
}
