local config = {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh", "bashrc", "bash_profile", "profile" },
    root_markers = { ".git/", ".bashrc", ".bash_profile", ".profile" },
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
        },
    },
}
vim.lsp.config("bashls", config)
return config
