vim.g.mapleader = " "

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", {}, 'Move selected block down')
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", {}, 'Move selected block up')

vim.keymap.set("n", "J", "mzJ`z", {}, 'Join lines')

vim.keymap.set("n", "Y", 'yy', {}, 'Alternative copy full line')

vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]], {}, 'copy selection to system clipboard')
vim.keymap.set("n", "<leader>Y", [["+Y]], {}, 'Copy current line to system clipboard')

vim.keymap.set("n", "<leader>q", ":wqa!<CR>", {}, 'Save and get out')

vim.keymap.set("n", "<leader>s", [[:%s///gI<Left><Left><Left><Left>]], {}, 'Replace in file')
vim.keymap.set("v", "<leader>s", [[:s///gI<Left><Left><Left><Left>]], {}, 'Replace in selection')

vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true }, 'Make current file executable')

vim.keymap.set("n", "<leader><leader>", function() vim.cmd("so") end, {}, 'source current file')
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")


---
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- vim.keymap.set("n", "n", "nzzzv")
-- vim.keymap.set("n", "N", "Nzzzv")

-- -- greatest remap ever
-- vim.keymap.set("x", "<leader>p", [["_dP]])
