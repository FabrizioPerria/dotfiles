return {
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        keys = {
            { "<leader>w", "<cmd>WhichKey<CR>", desc = "which-key leader" },
        },
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {
        }
    }
}
