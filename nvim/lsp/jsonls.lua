local config = {
    cmd = { "vscode-json-language-server", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
}
vim.lsp.config("jsonls", config)
return config
