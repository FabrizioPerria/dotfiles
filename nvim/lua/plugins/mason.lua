return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({})
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "vtsls",
                    "vue-language-server",

                    "debugpy",
                    "basedpyright",
                    "ruff",
                    "java-debug-adapter",
                    "jdtls",
                    "java-test",

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
                    "typescript-language-server",
                    "tailwindcss-language-server",
                    "eslint-lsp",
                    "prettierd",
                },
            })
        end,
    },
}
