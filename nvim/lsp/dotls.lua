vim.lsp.config("dotls", {
    cmd = { "dot-language-server", "--stdio" },
    filetypes = { "dot" },
    root_markers = { ".git/", "dotfile" },
    init_options = {
        provideFormatter = true,
    },
    settings = {
        dot = {
            validate = true,
        },
    },
})
