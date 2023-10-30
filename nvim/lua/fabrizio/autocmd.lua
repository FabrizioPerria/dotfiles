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
        -- command = 'nnoremap <buffer> <leader><leader> :w<CR>:vsplit<bar>term ./doit.sh<CR>'
        command = 'nnoremap <buffer> <leader><leader> :w<CR>:FloatermNew --autoclose=0 ./doit.sh<CR>'
    }
)
vim.api.nvim_create_autocmd(
    { 'FileType' },
    {
        pattern = { 'cs' },
        group = refresh,
        command = 'nnoremap <buffer> <leader><leader> :w<CR>:term dotnet build<CR>'
    }
)

vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        vim.lsp.buf.format()
    end,
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd('norm G')
        vim.cmd([[nnoremap <buffer> <Esc> :bd!<CR>]])
    end
})
