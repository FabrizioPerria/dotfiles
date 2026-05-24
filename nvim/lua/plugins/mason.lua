require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})

local tools = {
        "zls",
        "roslyn",
        "netcoredbg",

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

        -- "css-lsp",
        -- "typescript-language-server",
        -- "tailwindcss-language-server",
        -- "prettier",
        -- "html-lsp",
        -- "vtsls",
        -- "vue-language-server",

        "clang-format",
        "codelldb",

        "kotlin-debug-adapter",
        "kotlin-language-server",
        "powershell-editor-services",
}

if vim.loop.os_uname().machine ~= "aarch64" then
    table.insert(tools, "clangd")
end

require("mason-tool-installer").setup({
    ensure_installed = tools
})
