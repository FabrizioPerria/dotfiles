
local function get_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.offsetEncoding = { "utf-8", "utf-16" }
    capabilities.textDocument.completion.editsNearCursor = true
    return capabilities
end

local config = {
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin" },
    root_markers = {
        "pom.xml",
    },
    capabilities = get_capabilities(),
}
vim.lsp.config("kotlin_language_server", config)
return config
