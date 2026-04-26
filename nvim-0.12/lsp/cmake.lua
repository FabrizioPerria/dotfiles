local config = {
    cmd = { "cmake-language-server" },
    capabilities = vim.lsp.protocol.make_client_capabilities(),
    filetypes = { "cmake" },
    init_options = {
        buildDirectory = "build",
    },
    root_markers = { "CMakeLists.txt", ".git/" },
}
vim.lsp.config("cmake", config)
return config
