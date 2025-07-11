vim.api.nvim_create_user_command("EnableGo", function()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "gopls",
            "goimports",
            "gofumpt",
            "impl",
            "gomodifytags",
            "delve",
        },
    })
    require("mason-tool-installer").check_install(false, true)
end, {})

vim.api.nvim_create_user_command("EnableClangd", function()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "clangd",
            "clang-format",
            "codelldb",
        },
    })
    require("mason-tool-installer").check_install(false, true)
end, {})

vim.api.nvim_create_user_command("EnablePython", function()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "debugpy",
            "pyright",
        },
    })
    require("mason-tool-installer").check_install(false, true)
end, {})

return {
    {
        "williamboman/mason.nvim",
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "debugpy",

                    "goimports",
                    "gofumpt",
                    "impl",
                    "gomodifytags",
                    "delve",

                    "stylua",

                    "jsonlint",
                    "jq",
                    "yamllint",
                    "yamlfmt",

                    "commitlint",
                    "gitlint",

                    "markdownlint",
                    "vale",
                    "write-good",
                    "cspell",
                    "proselint",

                    "bash-debug-adapter",
                    "beautysh",
                    "shfmt",
                    "shellcheck",

                    "codespell",
                    "editorconfig-checker",

                    "prettierd",
                },
            })
        end,
    },
}
