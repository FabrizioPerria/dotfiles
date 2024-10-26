return {
    -- {
    --     "vhyrro/luarocks.nvim",
    --     priority = 1000,
    --     config = true,
    --     lazy = true,
    -- },
    -- {
    --     "rest-nvim/rest.nvim",
    --     ft = "http",
    --     dependencies = {
    --         "vhyrro/luarocks.nvim",
    --         "nvim-treesitter/nvim-treesitter",
    --         "nvim-telescope/telescope.nvim",
    --     },
    --     filetypes = { "http" },
    --     keys = {
    --         { "<leader>rr", "<cmd>Rest run<cr>",                  desc = "Run request under the cursor", },
    --         { "<leader>rl", "<cmd>Rest run last<cr>",             desc = "Re-run latest request", },
    --         { "<leader>re", "<cmd>Telescope rest select_env<cr>", desc = "Select environment file", },
    --
    --     },
    --     config = function()
    --         require("rest-nvim").setup({
    --             result = {
    --                 split = {
    --                     stay_in_current_window_after_split = false,
    --                 },
    --             },
    --         })
    --         require('telescope').load_extension('rest')
    --     end,
    -- },
    {
        "fabrizioperria/neotest-jdtls",
        ft = "java",
        lazy = true,
        dependencies = {
            "nvim-neotest/neotest",
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-jdtls")
                }
            })
        end,
    },
    {
        "nvim-neotest/neotest",
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            "nvim-neotest/nvim-nio",
            "nvim-lua/plenary.nvim",
            "antoinemadec/FixCursorHold.nvim",
            "nvim-treesitter/nvim-treesitter",
            "nvim-neotest/neotest-go",
            "nvim-neotest/neotest-python",
            { "alfaix/neotest-gtest", dependencies = {"nvim-treesitter/nvim-treesitter"} },
        },
        keys = {
            {
                "<leader>tt",
                function()
                    require("neotest").run.run(vim.fn.expand("%"))
                end,
                desc = "Run File",
            },
            {
                "<leader>td",
                function()
                    if vim.fn.expand("%:e") == "go" then
                        require("dap-go").debug_test()
                    elseif vim.fn.expand("%:e") == "java" then
                        require("java").test.debug_current_method()
                    else
                        require("neotest").run.debug(vim.fn.expand("%"))
                    end
                end,
                desc = "Debug Nearest (Go)",
            },
            {
                "<leader>tT",
                function()
                    require("neotest").run.run(vim.loop.cwd())
                end,
                desc = "Run All Test Files",
            },
            {
                "<leader>tr",
                function()
                    require("neotest").run.run({ strategy = "dap" })
                end,
                desc = "Run Nearest",
            },
            {
                "<leader>ts",
                function()
                    require("neotest").summary.toggle()
                end,
                desc = "Toggle Summary",
            },
            {
                "<leader>to",
                function()
                    require("neotest").output.open({ enter = true, auto_close = true })
                end,
                desc = "Show Output",
            },
            {
                "<leader>tO",
                function()
                    require("neotest").output_panel.toggle()
                end,
                desc = "Toggle Output Panel",
            },
            {
                "<leader>tS",
                function()
                    require("neotest").run.stop()
                end,
                desc = "Stop",
            },
        },
        config = function()
            require("neotest").setup({
                adapters = {
                    require("neotest-python")({
                        dap = { justMyCode = false },
                    }),
                    require("neotest-go")({
                        experimental = {
                            test_table = true,
                        },
                        args = { "-count=1", "-timeout=60s" },
                        -- recursive_run = true
                    }),
                    require("neotest-gtest"),
                },
            })
        end,
    },
}
