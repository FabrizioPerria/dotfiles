function open_build_terminal_csharp()
    vim.cmd("botright 10split") -- Open a split at the bottom
    vim.cmd("terminal dotnet build") -- Open terminal and run script
    vim.cmd("normal G") -- Scroll to bottom of terminal output

    -- In terminal mode, map <Esc> to close the terminal and the split
    vim.keymap.set("t", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("t", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.cs" },
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:lua open_build_terminal_csharp()<CR>",
})
local config = {
    settings = {
        ["csharp|inlay_hints"] = {
            csharp_enable_inlay_hints_for_implicit_object_creation = true,
            csharp_enable_inlay_hints_for_implicit_variable_types = true,
        },
        ["csharp|code_lens"] = {
            dotnet_enable_references_code_lens = true,
        },
    },
}
vim.lsp.config("roslyn", config)
return config
