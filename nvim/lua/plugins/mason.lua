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


        "stylua",
        "lua-language-server",
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

        "codespell",
        "docker-compose-language-service",
        "dockerfile-language-server",
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

if vim.fn.has('win32') == 0 then
    table.insert(tools, "ansible-language-server")
    table.insert(tools, "golangci-lint")
    table.insert(tools, "gopls")
    table.insert(tools, "goimports")
    table.insert(tools, "gofumpt")
    table.insert(tools, "impl")
    table.insert(tools, "gomodifytags")
    table.insert(tools, "delve")
    table.insert(tools, "neocmakelsp")
    table.insert(tools, "luacheck")
    table.insert(tools, "json-lsp")
    table.insert(tools, "dot-language-server")

end

require("mason-tool-installer").setup({
    ensure_installed = tools
})
