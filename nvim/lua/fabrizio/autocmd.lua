local refresh = vim.api.nvim_create_augroup('refresh', { clear = true })
vim.api.nvim_create_autocmd(
    { "BufRead", "BufNewFile" },
    {
        pattern = { "*.lua" },
        group = refresh,
        command = 'if expand("%:t") == "packer.lua" | nnoremap <buffer> <leader><leader> :w<CR>:so<CR>:PackerSync<CR> | else | nnoremap <buffer> <leader><leader> :w<CR>:so<CR> | endif'
    }
)

vim.api.nvim_create_autocmd(
    { 'FileType' },
    {
        pattern = { 'c', 'cpp', 'h', 'hpp' },
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

