local config = {
    cmd = { "gopls" },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git/" },
    settings = {
        gopls = {
            analyses = {
                unusedparams = true,
                shadow = true,
            },
            staticcheck = true,
            usePlaceholders = true,
            completeUnimported = true,
        },
    },
}
vim.lsp.config("gopls", config)
return config
