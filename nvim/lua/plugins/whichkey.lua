vim.o.timeout = true
vim.o.timeoutlen = 300

require("which-key").setup()

vim.keymap.set("n", "<leader>w", "<cmd>WhichKey<CR>", { desc = "which-key leader" })
