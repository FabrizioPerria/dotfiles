return {
    {
        "llllvvuu/nvim-cmp",
        branch = "feat/above",
        opts = function()
            require("cmp").setup({
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "top_down",
                        vertical_positioning = "above",
                    },
                    docs = {
                        auto_open = true,
                    },
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            setup = {
                clangd = function(_, opts)
                    opts.capabilities.offsetEncoding = { "utf-16" }
                end,
                gopls = function(_, opts)
                    opts.capabilities.offsetEncoding = { "utf-16" }
                end,
            },
        },
    },
}
