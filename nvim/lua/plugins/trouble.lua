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
        { "<leader>xd", "<cmd>Trouble diagnostics toggle<cr>", desc = "toggle Trouble diagnostics" },
        { "<leader>xq", "<cmd>Trouble qflist toggle<cr>",      desc = "toggle Trouble quickfix" },
        { "<leader>xs", "<cmd>Trouble symbols toggle<cr>",     desc = "toggle Trouble symbols" },
        {
            "[d",
            function()
                require("trouble").previous({ skip_groups = true, jump = true })
            end,
            desc = "previous item",
        },
        {
            "]d",
            function()
                require("trouble").next({ skip_groups = true, jump = true })
            end,
            desc = "next item",
        },
    },
}
