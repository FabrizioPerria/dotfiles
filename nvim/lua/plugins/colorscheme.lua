return {
    {
        "norcalli/nvim-colorizer.lua",
        config = function()
            require('colorizer').setup()
        end
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,

        config = function()
            vim.cmd("colorscheme tokyonight-storm")
            vim.api.nvim_set_hl(0, "RainbowRed", {
                fg = "#891d25"
            })
            vim.api.nvim_set_hl(0, "RainbowYellow", {
                fg = "#936a1b"
            })
            vim.api.nvim_set_hl(0, "RainbowBlue", {
                fg = "#0f5b99"
            })
            vim.api.nvim_set_hl(0, "RainbowOrange", {
                fg = "#784d24"
            })
            vim.api.nvim_set_hl(0, "RainbowGreen", {
                fg = "#4a6d31"
            })
            vim.api.nvim_set_hl(0, "RainbowViolet", {
                fg = "#712288"
            })
            vim.api.nvim_set_hl(0, "RainbowCyan", {
                fg = "#256067"
            })

            vim.api.nvim_set_hl(0, "DiffText", {
                bg = "#373640",
                fg = "#e0af68"
            })
            vim.api.nvim_set_hl(0, "DiffAdd", {
                bg = "#233745",
                fg = "#1abc9c"
            })
            vim.api.nvim_set_hl(0, "DiffChange", {
                bg = "#232323"
            })
            vim.api.nvim_set_hl(0, "DiffDelete", {
                bg = "#362c3d",
                fg = "#db4b4b"
            })
            vim.api.nvim_set_hl(0, "DiffDelete", {
                bg = "#360000",
                fg = "#db4b4b"
            })
            vim.api.nvim_set_hl(0, "DapBreakpoint", {
                ctermbg = 0,
                fg = "#993939",
                bg = "#31353f"
            })
            vim.api.nvim_set_hl(0, "DapLogPoint", {
                ctermbg = 0,
                fg = "#61afef",
                bg = "#31353f"
            })
            vim.api.nvim_set_hl(0, "DapStopped", {
                ctermbg = 0,
                fg = "#98c379",
                bg = "#31353f"
            })
            vim.api.nvim_set_hl(0, "LineNr", {
                fg = "#6f99bb"
            })
            vim.api.nvim_set_hl(0, "CursorLineNr", {
                bg = "#697fff",
                fg = "#ffffff"
            })
            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {
                fg = "#6CC644"
            })
            vim.api.nvim_set_hl(0, "SpecialKey", {
                fg = "#444444"
            })
            vim.cmd [[highlight Normal guibg=none]]
            vim.fn.sign_define("DapBreakpoint", {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint"
            })
            vim.fn.sign_define("DapBreakpointCondition", {
                text = "ﳁ",
                texthl = "DapBreakpoint",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint"
            })
            vim.fn.sign_define("DapBreakpointRejected", {
                text = "",
                texthl = "DapBreakpoint",
                linehl = "DapBreakpoint",
                numhl = "DapBreakpoint"
            })
            vim.fn.sign_define("DapLogPoint", {
                text = "",
                texthl = "DapLogPoint",
                linehl = "DapLogPoint",
                numhl = "DapLogPoint"
            })
            vim.fn.sign_define("DapStopped", {
                text = "",
                texthl = "DapStopped",
                linehl = "DapStopped",
                numhl = "DapStopped"
            })

            local signs = {
                Error = " ",
                Warn = " ",
                Hint = " ",
                Info = " "
            }

            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
            end
        end
    },
    {
        "norcalli/nvim-colorizer.lua",
        lazy = true,
        config = function()
            require("colorizer").setup()
        end,
        keys = {
            { "<leader>C", ":ColorizerToggle<CR>", desc = "Show Colors" }
        }
    }
}
