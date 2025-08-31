local config = {
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" },
            },
            workspace = {
                checkThirdParty = false,
                library = vim.api.nvim_get_runtime_file("", true),
            },
            telemetry = {
                enable = false,
            },
        },
    },
}
vim.lsp.config("lua_ls", config)
return config
