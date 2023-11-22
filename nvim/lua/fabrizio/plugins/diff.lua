return { 
    "sindrets/diffview.nvim",              
    config = function() 
        require("diffview").setup({
        view = {
            merge_tool = {
                layout = "diff3_mixed",
                disable_diagnostics = false,
            },
        },
    })
    end,
    enabled = vim.g.vscode == 0, 
    lazy=false
}