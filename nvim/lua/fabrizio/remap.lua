vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {}, 'Move selected block down')
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {}, 'Move selected block up')

vim.keymap.set("n", "J", "mzJ`z", {}, 'Join lines')

vim.keymap.set("n", "Y", 'yy', {}, 'Alternative copy full line')

vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
