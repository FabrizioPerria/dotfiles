return {
    {
        "RaafatTurki/hex.nvim",
        event = "VeryLazy",
        lazy = true,
        config = function()
            require("hex").setup()
        end,
        keys = {
            {
                "<leader>0x",
                function()
                    require("hex").toggle()
                end,
                desc = "Toggle hex view",
            },
        },
    },
}
