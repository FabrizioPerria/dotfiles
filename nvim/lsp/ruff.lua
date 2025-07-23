local config = {
    cmd = { "ruff-lsp", "--stdio" },
    filetypes = { "python" },
    root_markers = { ".git/", "pyproject.toml", "ruff.toml", "ruff.yaml", "ruff.yml" },
    init_options = {
        settings = {
            args = { "--line-length=88" },
            format = {
                enable = true,
            },
            lint = {
                enable = true,
            },
        },
    },
}
vim.lsp.config("ruff", config)
return config
