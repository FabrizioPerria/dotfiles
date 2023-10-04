require('refactoring').setup({
    prompt_func_return_type = {
        go = true,
        cpp = true,
        c = true,
    },
    prompt_func_param_type = {
        go = true,
        cpp = true,
        c = true,
    },
})

vim.keymap.set(
    { "n", "x", 'v' },
    "<leader>rr",
    function() require('refactoring').select_refactor() end
)

vim.api.nvim_set_keymap("v", "<leader>ri", [[ <Esc><Cmd>lua require('refactoring').refactor('Inline Variable')<CR>]],
    { noremap = true, silent = true, expr = false })

vim.keymap.set("x", "<leader>re", ":Refactor extract ")
vim.keymap.set("x", "<leader>rf", ":Refactor extract_to_file ")

vim.keymap.set("x", "<leader>rv", ":Refactor extract_var ")

vim.keymap.set({ "n", "x" }, "<leader>ri", ":Refactor inline_var")

vim.keymap.set("n", "<leader>rI", ":Refactor inline_func")

vim.keymap.set("n", "<leader>rb", ":Refactor extract_block")
vim.keymap.set("n", "<leader>rbf", ":Refactor extract_block_to_file")
