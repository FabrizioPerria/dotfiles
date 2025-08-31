return {
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                registries = {
                    "github:mason-org/mason-registry",
                    "github:Crashdummyy/mason-registry",
                },
            })
        end,
    },
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        config = function()
            require("mason-tool-installer").setup({
                ensure_installed = {
                    "roslyn",

                    "vtsls",
                    "vue-language-server",

                    "debugpy",
                    "basedpyright",
                    "java-debug-adapter",
                    "jdtls",
                    "java-test",
                    "checkstyle",

                    "ruff",
                    "isort",

                    "golangci-lint",
                    "gopls",
                    "goimports",
                    "gofumpt",
                    "impl",
                    "gomodifytags",
                    "delve",

                    "cmake-language-server",

                    "stylua",
                    "lua-language-server",
                    "luacheck",

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
                    "prettier",

                    "clangd",
                    "clang-format",
                    "codelldb",
                },
            })
        end,
    },
}
