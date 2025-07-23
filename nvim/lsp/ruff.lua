vim.lsp.config("ruff", {
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
})
