local config = {
    cmd = { "docker-compose-langserver", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "yaml", "yml" },
    root_markers = { ".git/", "docker-compose.yml", "docker-compose.yaml" },
    on_attach = function(client, bufnr)
        local fname = vim.api.nvim_buf_get_name(bufnr)
        if not fname:match("docker%-compose%.ya?ml$") then
            vim.defer_fn(function()
                vim.lsp.buf_detach_client(bufnr, client.id)
            end, 0)
        end
    end,
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
