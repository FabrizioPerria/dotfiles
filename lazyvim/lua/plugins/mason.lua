return {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "pyright",
        "mypy",
        "ruff",
        "black",
        "debugpy",

        "clangd",
        "clang-format",
        "codelldb",
        "cmake-language-server",

        -- "gopls",

        "stylua",

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
    },
  },
}
