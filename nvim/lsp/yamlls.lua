local config = {
    cmd = { "yaml-language-server", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
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
