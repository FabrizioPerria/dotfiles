local function get_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = { "utf-8", "utf-16" }
    capabilities.textDocument.completion.editsNearCursor = true
    return capabilities
end

local config = {
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin", "kotlin-script" },
    root_markers = {
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "gradlew",
        ".git",
    },
    capabilities = get_capabilities(),
}
vim.lsp.config("kotlin_language_server", config)
return config
