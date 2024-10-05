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
    -- command = 'nnoremap <buffer> <leader><leader> :w<CR>:vsplit<bar>term ./doit.sh<CR>'
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:FloatermNew --autoclose=0 ./build.sh<CR>",
})

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("norm G")
        vim.cmd([[nnoremap <buffer> <Esc> :bd!<CR>]])
    end,
})

vim.api.nvim_create_user_command("EnableGo", function()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "gopls",
            "goimports",
            "gofumpt",
            "impl",
            "gomodifytags",
            "delve",
        },
    })
end, {})

vim.api.nvim_create_user_command("EnableClangd", function()
    require("mason-tool-installer").setup({
        ensure_installed = {
            "clangd",
            "clang-format",
            "codelldb",
        },
    })
end, {})
