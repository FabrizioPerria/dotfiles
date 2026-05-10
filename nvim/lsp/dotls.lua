local config = {
    cmd = { "dot-language-server", "--stdio" },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
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
}
vim.lsp.config("dotls", config)
return config
