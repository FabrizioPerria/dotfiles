vim.lsp.config("bashls", {
    cmd = { "bash-language-server", "start" },
    filetypes = { "sh", "bash", "zsh", "bashrc", "bash_profile", "profile" },
    root_markers = { ".git/", ".bashrc", ".bash_profile", ".profile" },
    settings = {
        bashIde = {
            globPattern = "*@(.sh|.inc|.bash|.command)",
        },
    },
})
