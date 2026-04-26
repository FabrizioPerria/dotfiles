local config = {
    cmd = { "cmake-language-server" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = { "cmake" },
    init_options = {
        buildDirectory = "build",
    },
    root_markers = { "CMakeLists.txt", ".git/" },
}
vim.lsp.config("cmake", config)
return config
