return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                ui = {
                    icons = {
                        package_installed = "✓",
                        package_pending = "➜",
                        package_uninstalled = "✗",
                    },
                },
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        config = function()
            require("mason-lspconfig").setup()
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    -- "basedpyright",
                    "mypy",
                    "ruff",
                    "black",
                    "debugpy",

                    -- "clangd",
                    "clang-format",
                    "codelldb",
                    "cmake-language-server",

                    "gopls",
                    "goimports",
                    "gofumpt",
                    "impl",
                    "gomodifytags",
                    "delve",

                    -- "java-language-server",

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
                    -- "misspell",
                    "proselint",

                    "bash-language-server",
                    "bash-debug-adapter",
                    "beautysh",
                    "shfmt",
                    "shellcheck",
                    -- "shellharden",

                    "ansible-language-server",
                    "css-lsp",
                    "codespell",
                    "dockerfile-language-server",
                    "dot-language-server",
                    "editorconfig-checker",
                    -- "html-lsp",

                    -- "csharp-language-server",
                },
            })
        end,
    },
}
