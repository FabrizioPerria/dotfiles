local config = {
    cmd = { "gopls" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "go", "gomod", "gowork", "gotmpl" },
    root_markers = { "go.mod", "go.work", ".git/" },
    init_options = {
        usePlaceholders = true,
        completeUnimported = true,
        staticcheck = true,
    },
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
