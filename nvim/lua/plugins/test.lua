return {
    {
        "rcasia/neotest-java",
        ft = "java",
        dependencies = {
            "mfussenegger/nvim-jdtls",
            "mfussenegger/nvim-dap", -- for the debugger
            "rcarriga/nvim-dap-ui", -- recommended
            "theHamsta/nvim-dap-virtual-text", -- recommended
        },
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
            "rcasia/neotest-java",
            "alfaix/neotest-gtest",
        },
        keys = {
            {
                "<leader>tt",
                function()
                    if vim.fn.expand("%:e") == "java" then
                        require("jdtls").test_class()
                    else
                        require("neotest").run.run(vim.fn.expand("%"))
                    end
                end,
                desc = "Run File",
            },
            {
                "<leader>td",
                function()
                    if vim.fn.expand("%:e") == "go" then
                        require("dap-go").debug_test()
                    elseif vim.fn.expand("%:e") == "java" then
                        require("jdtls").test_nearest_method()
                    else
                        -- require("neotest").run.debug(vim.fn.expand("%"))
                        require("neotest").run.run({ strategy = "dap", file = vim.fn.expand("%") })
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
                    require("neotest").run.run({ strategy = "integrated" })
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
                        -- Use python from virtualenv
                        python = ".venv/bin/python",
                        args = { "--import-mode=importlib" },
                        runner = "pytest",
                    }),
                    require("neotest-go")({
                        experimental = {
                            test_table = true,
                        },
                        args = { "-count=1", "-timeout=60s" },
                        -- recursive_run = true
                    }),
                    require("neotest-gtest"),
                    require("neotest-java")({
                        incremental_build = true,
                    }),
                },
            })
        end,
    },
}
