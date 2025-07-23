vim.lsp.config("jsonls", {
    cmd = { "vscode-json-language-server", "--stdio" },
    filetypes = { "json", "jsonc" },
    root_markers = { ".git/", "package.json", "tsconfig.json", "jsconfig.json" },
    init_options = {
        provideFormatter = true,
    },
    settings = {
        json = {
            validate = { enable = true },
        },
    },
})
