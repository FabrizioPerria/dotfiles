local virtual_text_enabled = false

function ToggleDiagnosticVirtualText()
    virtual_text_enabled = not virtual_text_enabled
    vim.diagnostic.config({
        virtual_text = virtual_text_enabled and { spacing = 2, prefix = "●" } or false,
    })
end

local refresh = vim.api.nvim_create_augroup("refresh", {
    clear = true,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    group = refresh,
    command = "set formatoptions-=cro",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "dashboard" },
    group = refresh,

    command = "lua vim.b.miniindentscope_disable=true",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "CMakeLists.txt" },
    group = refresh,
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:FloatermNew --autoclose=0 ./build.sh<CR>",
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("norm G")
        vim.cmd([[nnoremap <buffer> <Esc> :bd!<CR>]])
    end,
})
function ShowDiagnosticsHover()
    local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "if_many",
        scope = "cursor",
        max_width = 80,
        max_height = 15,
    }

    local float_bufnr, float_winnr = vim.diagnostic.open_float(nil, opts)

    if float_winnr and vim.api.nvim_win_is_valid(float_winnr) then
        vim.api.nvim_win_set_option(float_winnr, "wrap", true)
        vim.api.nvim_win_set_option(float_winnr, "linebreak", true)
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        vim.keymap.set("n", "<leader>a", function()
            require("actions-preview").code_actions()
        end, {})
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", {})
        vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", {})
        vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", {})
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", {})
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", {})
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", {})
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", {})
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", {})
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", {})
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {})
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", {})

        vim.keymap.set("n", "<leader>dd", ShowDiagnosticsHover, { desc = "Toggle diagnostic virtual text" })

        vim.diagnostic.config({
            underline = false,
            virtual_text = virtual_text_enabled,
            update_in_insert = false,
            severity_sort = true,
            signs = {
                text = {
                    -- Alas nerdfont icons don't render properly on Medium!
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
        })
        vim.api.nvim_set_hl(0, "FloatBorder", { bg = "#1e222a", fg = "#5e81ac" })
        vim.keymap.set("n", "gl", function()
            vim.diagnostic.open_float(nil, {
                border = "rounded",
                scope = "line",
                float_opts = {
                    winblend = 0,
                    highlight = { bg = "#1e222a" },
                },
            })
        end, {})
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", {})
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", {})
    end,
})
