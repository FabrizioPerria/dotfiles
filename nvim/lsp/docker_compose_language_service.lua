local config = {
    cmd = { "docker-compose-langserver", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "yaml", "yml" },
    root_markers = { ".git/", "docker-compose.yml", "docker-compose.yaml" },
    init_options = {
        dockerCompose = {
            lint = {
                enabled = true,
                rules = {
                    ["DC1000"] = true, -- Use version 3 or higher
                    ["DC1001"] = true, -- Use services instead of containers
                    ["DC1002"] = true, -- Use networks instead of links
                    ["DC1003"] = true, -- Use volumes instead of bind mounts
                },
            },
        },
    },
}
vim.lsp.config("docker_compose_language_service", config)
return config
