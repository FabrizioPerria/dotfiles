vim.keymap.set( { "n", "o", "x" }, "<C-w>", ":lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
vim.keymap.set( { "n", "o", "x" }, "<C-e>", ":lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
vim.keymap.set( { "n", "o", "x" }, "<C-b>", ":lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
