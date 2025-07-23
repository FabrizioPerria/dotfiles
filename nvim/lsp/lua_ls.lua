local config = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
vim.lsp.config("lua_ls", config)
return config
