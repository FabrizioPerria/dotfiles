local config = {
    cmd = { "yaml-language-server", "--stdio" },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    filetypes = { "yaml" },
    root_markers = { ".git/", "yamllint.yaml", "yamlconfig.yaml" },
    settings = {
        yaml = {
            validate = true,
        },
        redhat = {
            telemetry = {
                enabled = false,
            },
        },
    },
}
vim.lsp.config("yamlls", config)
return config
