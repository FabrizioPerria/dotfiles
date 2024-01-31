if not vim.g.vscode then
    require("diffview").setup({
        view = {
            merge_tool = {
                layout = "diff3_mixed",
                disable_diagnostics = false,
            },
        },
    })

end
