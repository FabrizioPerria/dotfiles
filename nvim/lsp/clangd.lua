local function get_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.offsetEncoding = { "utf-8", "utf-16" }
    capabilities.textDocument = {
        completion = {
            editsNearCursor = true,
        },
    }
    return capabilities
end

local config = {
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
    capabilities = get_capabilities(),
}
vim.lsp.config("clangd", config)
return config
