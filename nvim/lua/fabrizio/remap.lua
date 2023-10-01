vim.g.mapleader = " "

-- Show buffers
vim.keymap.set('n', '<leader>b', ':buffers<CR>')

-- Move block selection
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- Better J
vim.keymap.set("n", "J", "mzJ`z")

-- yank line
vim.keymap.set("n", "Y", 'yy')

-- copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- save and get out
vim.keymap.set("n", "<leader>q", ":wqa!<CR>")

-- format file
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)


-- replace template
vim.keymap.set("n", "<leader>s", [[:%s///gI<Left><Left><Left><Left>]])
vim.keymap.set("v", "<leader>s", [[:s///gI<Left><Left><Left><Left>]])

-- make current file executable
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

--- lol
vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)


---
-- vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- greatest remap ever
vim.keymap.set("x", "<leader>p", [["_dP]])
