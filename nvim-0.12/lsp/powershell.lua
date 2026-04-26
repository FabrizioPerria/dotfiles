local bundle = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services"

if vim.fn.has("win32") == 1 then
    vim.env.PATH = vim.env.PATH .. ";C:\\Program Files\\WindowsPowerShell"
end

local config = {
    filetypes = { "ps1", "psm1", "psd1" },
    bundle_path = bundle,
    cmd = {
        "pwsh",
        "-NoLogo",
        "-NoProfile",
        "-Command",
        string.format(
            "& '%s/PowerShellEditorServices/Start-EditorServices.ps1' -BundledModulesPath '%s' -LogPath '%s' -SessionDetailsPath '%s' -FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0 -HostVersion 1.0.0 -Stdio -LogLevel Normal",
            bundle,
            bundle,
            vim.fn.stdpath("cache") .. "/nvim/powershell_es.log",
            vim.fn.stdpath("cache") .. "/nvim/powershell_es.session.json"
        ),
    },
    lsp_log_level = "Warning",
    init_options = { enableProfileLoading = false },
    on_attach = function(client)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,
}

vim.lsp.config("powershell_es", config)
return config
