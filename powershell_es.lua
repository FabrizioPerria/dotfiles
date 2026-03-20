vim.env.PATH = vim.env.PATH .. ";C:\\Program Files\\WindowsPowerShell"
local config = {
    filetypes = { "ps1", "psm1", "psd1" },
    -- bundle_path = "C:/Users/fabriziop/.vscode/extensions/ms-vscode.powershell-2025.4.0/modules",
    bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
    -- settings = { powershell = { codeFormatting = { Preset = "OTBS" } } },
    lsp_log_level = "Warning",
    init_options = {
        enableProfileLoading = false,
    },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}

vim.lsp.config("powershell_es", config)
return config
