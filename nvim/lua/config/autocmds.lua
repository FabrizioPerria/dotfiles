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
