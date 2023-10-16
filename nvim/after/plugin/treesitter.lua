if not vim.g.vscode then
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { "vimdoc", "javascript", "typescript", "c", "lua", "rust", "python" },
        sync_install = false,
        auto_install = true,

        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
    }
end
