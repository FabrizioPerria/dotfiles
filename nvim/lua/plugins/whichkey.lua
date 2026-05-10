vim.o.timeout = true
vim.o.timeoutlen = 300

require("which-key").setup()

vim.keymap.set("n", "<leader>w", "<cmd>WhichKey<CR>", { desc = "which-key leader" })

vim.keymap.set("i", "<C-Space>", function()
    vim.lsp.completion.get()
end, { desc = "Trigger LSP completion" })
