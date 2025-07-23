local config = {
    cmd = { "cmake-language-server" },
    filetypes = { "cmake" },
    init_options = {
        buildDirectory = "build",
    },
    root_markers = { "CMakeLists.txt", ".git/" },
}
vim.lsp.config("cmake", config)
return config
