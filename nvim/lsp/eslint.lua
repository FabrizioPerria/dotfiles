local config = {
    cmd = { "vscode-eslint-language-server", "--stdio" },
    filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    root_markers = { ".eslintrc.js", ".eslintrc.json", ".eslintrc.yaml", ".eslintrc.yml", "package.json" },
    init_options = {
        provideFormatter = true,
    },
    workspace_required = true,
    settings = {
        eslint = {
            enable = true,
            packageManager = "npm",
            codeActionOnSave = {
                mode = "all",
            },
            format = {
                enable = true,
            },
        },
        codeAction = {
            disableRuleComment = {
                enable = true,
                location = "separateLine",
            },
            showDocumentation = {
                enable = true,
            },
        },
        codeActionOnSave = {
            enable = false,
            mode = "all",
        },
        experimental = {
            useFlatConfig = false,
        },
        format = true,
        nodePath = "",
        onIgnoredFiles = "off",
        problems = {
            shortenToSingleLine = false,
        },
        quiet = false,
        rulesCustomizations = {},
        run = "onType",
        useESLintClass = false,
        validate = "on",
        workingDirectory = {
            mode = "location",
        },
    },
}
vim.lsp.config("eslint", config)
return config
