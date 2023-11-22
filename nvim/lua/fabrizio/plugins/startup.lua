return { 
    'startup-nvim/startup.nvim',
    config = function() require("startup").setup({ theme = "themes.startify2" }) end,
    enabled = vim.g.vscode == 0,
    lazy = false,
    priority = 1000,
}
