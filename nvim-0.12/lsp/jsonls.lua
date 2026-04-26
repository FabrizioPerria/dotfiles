local config = {
    cmd = { "vscode-json-language-server", "--stdio" },
    capabilities = (function()
        local caps = vim.lsp.protocol.make_client_capabilities()
        caps.textDocument.completion.completionItem.snippetSupport = true
        return caps
    end)(),
    filetypes = { "json", "jsonc" },
    root_markers = { ".git/", "package.json", "tsconfig.json", "jsconfig.json" },
    init_options = {
        provideFormatter = true,
    },
    settings = {
        json = {
            validate = { enable = true },
            schemas = {
                { fileMatch = { "package.json" }, url = "https://json.schemastore.org/package.json" },
                { fileMatch = { "tsconfig*.json" }, url = "https://json.schemastore.org/tsconfig.json" },
                { fileMatch = { ".eslintrc", ".eslintrc.json" }, url = "https://json.schemastore.org/eslintrc.json" },
                {
                    fileMatch = { ".prettierrc", ".prettierrc.json" },
                    url = "https://json.schemastore.org/prettierrc.json",
                },
                {
                    fileMatch = { "docker-compose.yml", "docker-compose.yaml" },
                    url = "https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json",
                },
            },
        },
    },
}
vim.lsp.config("jsonls", config)
return config
