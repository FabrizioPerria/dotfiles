return {
    {
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        dependencies = {
            "williamboman/mason.nvim",
        },
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
