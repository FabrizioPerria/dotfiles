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
        scope = "line",
        max_width = 80,
        max_height = 15,
        float_opts = {
            winblend = 0,
            highlight = { bg = "#1e222a" },
        },
    }

    local float_bufnr, float_winnr = vim.diagnostic.open_float(nil, opts)

    if float_winnr and vim.api.nvim_win_is_valid(float_winnr) then
        vim.api.nvim_win_set_option(float_winnr, "wrap", true)
        vim.api.nvim_win_set_option(float_winnr, "linebreak", true)
    end
end
