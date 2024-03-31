return {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
    config = function()
        require("trouble").setup({
            auto_open = false,
            auto_close = true,
            auto_preview = false,
            auto_fold = false,
            -- signs = {
            --     error = " ",
            --     warn = " ",
            --     hint = " ",
            --     info = " ",
            --     other = " ",
            -- },
            -- use_diagnostic_signs = false
        })
    end,
    keys = {
        { "<leader>xs", "<cmd>TroubleToggle<cr>", desc = "toggle Trouble" },
        {
            "[d",
            function()
                require("trouble").previous({ skip_groups = true, jump = true })
            end,
            "previous item",
        },
        {
            "]d",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end,
            "next item",
        },
    },
}
