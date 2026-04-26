require("neotest").setup({
    adapters = {
        require("neotest-python")({
            dap = { justMyCode = false },
            python = ".venv/bin/python",
            args = { "--import-mode=importlib" },
            runner = "pytest",
        }),
        require("neotest-go")({
            experimental = { test_table = true },
            args = { "-count=1", "-timeout=60s" },
        }),
        require("neotest-gtest"),
        require("neotest-jdtls"),
        require("neotest-dotnet")({ discovery_root = "solution" }),
    },
})

vim.keymap.set("n", "<leader>tt", function()
    require("neotest").run.run(vim.fn.expand("%"))
end, { desc = "Run File" })
vim.keymap.set("n", "<leader>td", function()
    if vim.fn.expand("%:e") == "go" then
        require("dap-go").debug_test()
    elseif vim.fn.expand("%:e") == "cs" then
        require("neotest").run.run({ strategy = "dap" })
    else
        require("neotest").run.run({ strategy = "dap", file = vim.fn.expand("%") })
    end
end, { desc = "Debug Nearest" })
vim.keymap.set("n", "<leader>tT", function()
    require("neotest").run.run(vim.loop.cwd())
end, { desc = "Run All Test Files" })
vim.keymap.set("n", "<leader>tr", function()
    require("neotest").run.run({ strategy = "integrated" })
end, { desc = "Run Nearest" })
vim.keymap.set("n", "<leader>ts", function()
    require("neotest").summary.toggle()
end, { desc = "Toggle Summary" })
vim.keymap.set("n", "<leader>to", function()
    require("neotest").output.open({ enter = true, auto_close = true })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "neotest-output",
        once = true,
        callback = function()
            vim.keymap.set("n", "<Esc>", "<cmd>close<CR>", { buffer = true, silent = true })
            vim.keymap.set("n", "q", "<cmd>close<CR>", { buffer = true, silent = true })
        end,
    })
end, { desc = "Show Output" })
vim.keymap.set("n", "<leader>tO", function()
    require("neotest").output_panel.toggle()
end, { desc = "Toggle Output Panel" })
vim.keymap.set("n", "<leader>tS", function()
    require("neotest").run.stop()
end, { desc = "Stop" })
