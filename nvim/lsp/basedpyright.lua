local config = {
    cmd = { "basedpyright-langserver", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
    },
    settings = {
        basedpyright = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "openFilesOnly",
                useLibraryCodeForTypes = true,
            },
        },
    },
}

vim.lsp.config("basedpyright", config)

return config
