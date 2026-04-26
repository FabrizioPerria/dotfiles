local handle = io.popen("zsh -l -c '~/.config/shell/detect_system_style.zsh' 2>&1")
local result = handle:read("*a")
handle:close()
local is_dark = result:match("dark") ~= nil

require("tokyonight").setup({
    style = is_dark and "storm" or "day",
    on_highlights = function(hl, _)
        hl.DiffText = { bg = "#373640", fg = "#e0af68" }
        hl.DiffAdd = { bg = "#233745", fg = "#1abc9c" }
        hl.DiffChange = { bg = "#232323" }
        hl.DiffDelete = { bg = "#360000", fg = "#db4b4b" }

        hl.DapBreakpoint = { fg = "#993939", bg = "#31353f" }
        hl.DapLogPoint = { fg = "#61afef", bg = "#31353f" }
        hl.DapStopped = { fg = "#98c379", bg = "#31353f" }

        hl.LineNr = { fg = "#61afef" }
        hl.LineNrAbove = { fg = "#61afef" }
        hl.LineNrBelow = { fg = "#61afef" }
        hl.CursorLineNr = { bg = "#697fff", fg = "#ffffff" }
        hl.SpecialKey = { fg = "#444444" }
        hl.FloatBorder = { bg = "#1e222a", fg = "#5e81ac" }

        hl.StatusLine = { fg = "#a9b1d6", bg = "#2a2d3e" }
        hl.StatusLineNC = { fg = "#444b6a", bg = "#1a1b26" }
    end,
})
vim.cmd("colorscheme tokyonight")

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.wo.winhighlight = "Normal:TermNormal"
    end,
})
vim.api.nvim_set_hl(0, "TermNormal", { bg = "#0d0f17" })

local dap_signs = {
    Breakpoint = { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" },
    BreakpointCondition = { text = "ﳁ", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" },
    BreakpointRejected = { text = "", texthl = "DapBreakpoint", linehl = "DapBreakpoint", numhl = "DapBreakpoint" },
    LogPoint = { text = "", texthl = "DapLogPoint", linehl = "DapLogPoint", numhl = "DapLogPoint" },
    Stopped = { text = "", texthl = "DapStopped", linehl = "DapStopped", numhl = "DapStopped" },
}
for name, sign in pairs(dap_signs) do
    vim.fn.sign_define("Dap" .. name, sign)
end

vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.HINT] = " ",
            [vim.diagnostic.severity.INFO] = " ",
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

require("colorizer").setup()
require("marks").setup()

vim.keymap.set("n", "<leader>C", ":ColorizerToggle<CR>", { desc = "Show Colors" })
