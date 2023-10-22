local refresh = vim.api.nvim_create_augroup('refresh', { clear = true })
vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = { "*.lua" },
        group = refresh,
        command =
        'if expand("%:t") == "packer.lua" | nnoremap <buffer> <leader><leader> :w<CR>:so<CR>:PackerSync<CR> | else | nnoremap <buffer> <leader><leader> :w<CR>:so<CR> | endif'
    }
)

vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = { '*.c', '*.cpp', '*.h', '*.hpp', 'CMakeLists.txt' },
        group = refresh,
        command = 'nnoremap <buffer> <leader><leader> :w<CR>:!./doit.sh<CR>'
        -- command = 'nnoremap <buffer> <leader><leader> :w<CR>:!clang++ %<CR>'
    }
)
vim.api.nvim_create_autocmd(
    { 'FileType' },
    {
        pattern = { 'cs' },
        group = refresh,
        command = 'nnoremap <buffer> <leader><leader> :w<CR>:!dotnet build<CR>'
    }
)

-- vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
vim.api.nvim_create_autocmd("BufWritePre", {
    -- group = augroup,
    -- buffer = bufnr,
     pattern = {"*.h", "*.cpp"},
    callback = function()
        vim.lsp.buf.format()
    end,
})
