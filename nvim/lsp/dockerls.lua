local config = {
    cmd = { "docker-langserver", "--stdio" },
    filetypes = { "dockerfile" },
    root_markers = { ".git/", "Dockerfile" },
    init_options = {
        dockerfile = {
            lint = {
                enabled = true,
                rules = {
                    ["DL3000"] = true, -- Use WORKDIR to switch to a directory
                    ["DL3001"] = true, -- Use COPY instead of ADD
                    ["DL3002"] = true, -- Use COPY instead of ADD with URLs
                    ["DL3003"] = true, -- Use COPY instead of ADD with local files
                },
            },
        },
    },
}
vim.lsp.config("dockerls", config)
return config
