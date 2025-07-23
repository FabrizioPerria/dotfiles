vim.lsp.config("cssls", {
    cmd = { "vscode-css-language-server", "--stdio" },
    filetypes = {
        "css",
        "scss",
        "less",
    },
    init_options = {
        provideFormatter = true,
    },
    root_markers = {
        ".git/",
        "package.json",
        "bower.json",
        "composer.json",
    },
    settings = {
        css = {
            validate = true,
        },
        less = {
            validate = true,
        },
        scss = {
            validate = true,
        },
    },
})
