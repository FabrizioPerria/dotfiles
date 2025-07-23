local config = {
    cmd = { "yaml-language-server", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "yaml" },
    root_markers = { ".git/", "yamllint.yaml", "yamlconfig.yaml" },
    settings = {
        yaml = {
            schemas = {
                ["https://raw.githubusercontent.com/ansible-community/schemas/main/ansible-2.9.json"] = "/*",
                ["https://raw.githubusercontent.com/ansible-community/schemas/main/ansible-3.0.json"] = "/*",
            },
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
