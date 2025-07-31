return {
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- Set colorscheme
            require("tokyonight").setup({
                style = "storm",
                on_highlights = function(hl, _)
                    -- Diff colors
                    hl.DiffText = { bg = "#373640", fg = "#e0af68" }
                    hl.DiffAdd = { bg = "#233745", fg = "#1abc9c" }
                    hl.DiffChange = { bg = "#232323" }
                    hl.DiffDelete = { bg = "#360000", fg = "#db4b4b" }

                    -- DAP colors
                    hl.DapBreakpoint = { fg = "#993939", bg = "#31353f" }
                    hl.DapLogPoint = { fg = "#61afef", bg = "#31353f" }
                    hl.DapStopped = { fg = "#98c379", bg = "#31353f" }

                    -- UI elements
                    hl.LineNr = { fg = "#61afef" }
                    hl.LineNrAbove = { fg = "#61afef" }
                    hl.LineNrBelow = { fg = "#61afef" }
                    hl.CursorLineNr = { bg = "#697fff", fg = "#ffffff" }
                    hl.CmpItemKindCopilot = { fg = "#6CC644" }
                    hl.SpecialKey = { fg = "#444444" }
                    hl.FloatBorder = { bg = "#1e222a", fg = "#5e81ac" }
                end,
            })
            vim.cmd("colorscheme tokyonight")

            local dap_signs = {
                Breakpoint = {
                    text = "",
                    texthl = "DapBreakpoint",
                    linehl = "DapBreakpoint",
                    numhl = "DapBreakpoint",
                },
                BreakpointCondition = {
                    text = "ﳁ",
                    texthl = "DapBreakpoint",
                    linehl = "DapBreakpoint",
                    numhl = "DapBreakpoint",
                },
                BreakpointRejected = {
                    text = "",
                    texthl = "DapBreakpoint",
                    linehl = "DapBreakpoint",
                    numhl = "DapBreakpoint",
                },
                LogPoint = {
                    text = "",
                    texthl = "DapLogPoint",
                    linehl = "DapLogPoint",
                    numhl = "DapLogPoint",
                },
                Stopped = {
                    text = "",
                    texthl = "DapStopped",
                    linehl = "DapStopped",
                    numhl = "DapStopped",
                },
            }
            for name, sign in pairs(dap_signs) do
                vim.fn.sign_define("Dap" .. name, sign)
            end

            vim.diagnostic.config({
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = " ",
                        [vim.diagnostic.severity.WARN] = " ",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                    linehl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                    },
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                    },
                },
            })
        end,
    },
    {
        "norcalli/nvim-colorizer.lua",
        lazy = true,
        config = function()
            require("colorizer").setup()
        end,
        keys = {
            { "<leader>C", ":ColorizerToggle<CR>", desc = "Show Colors" },
        },
    },
    {
        "chentoast/marks.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
