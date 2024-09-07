return {
    {
        'RaafatTurki/hex.nvim',
        event = "VeryLazy",
        config = function()
            require 'hex'.setup()
        end,
        keys = {
            { "<leader>xxx", function() require 'hex'.toggle() end, desc = "Toggle hex view" }
        }
    }

}
