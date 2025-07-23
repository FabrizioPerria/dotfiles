local config = {
    cmd = { "marksman", "server" },
    filetypes = { "markdown" },
    root_markers = { ".git/", "README.md", "index.md" },
    init_options = {
        enableMarkdownLinks = true,
        enableMarkdownCodeActions = true,
        enableMarkdownDiagnostics = true,
        enableMarkdownCompletion = true,
    },
    settings = {
        marksman = {
            diagnostics = {
                enabled = true,
            },
            completion = {
                enabled = true,
            },
        },
    },
}
vim.lsp.config("marksman", config)
return config
