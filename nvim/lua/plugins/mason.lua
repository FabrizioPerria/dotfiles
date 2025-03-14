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
                    -- "pyright",
                    "basedpyright",
                    "ruff",
                    -- "pylsp",
                    "volar",

                    "gopls",
                    "goimports",
                    "gofumpt",
                    "impl",
                    "gomodifytags",
                    "delve",

                    "cmake-language-server",

                    "stylua",
                    "lua-language-server",

                    "json-lsp",
                    "jsonlint",
                    "jq",
                    "yaml-language-server",
                    "yamllint",
                    "yamlfmt",

                    "commitlint",
                    "gitlint",

                    "marksman",
                    "markdownlint",
                    "vale",
                    "write-good",
                    "cspell",
                    "proselint",

                    "bash-language-server",
                    "bash-debug-adapter",
                    "beautysh",
                    "shfmt",
                    "shellcheck",

                    "ansible-language-server",
                    "codespell",
                    "docker-compose-language-service",
                    "dockerfile-language-server",
                    "dot-language-server",
                    "editorconfig-checker",

                    "css-lsp",
                    -- "tsserver",
                    "ts_ls",
                    "tailwindcss",
                    "eslint-lsp",
                    "prettierd",
                },
            })
        end,
    },
}
