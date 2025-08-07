vim.g.mapleader = " "

vim.keymap.set({ "n" }, "<leader>L", ":Lazy<CR>", { desc = "Lazy Dashboard" })

vim.keymap.set("n", "J", "mzJ`z", { noremap = true, desc = "Join lines" })
--
vim.keymap.set("n", "<leader>bv", ":vsplit<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<leader>bh", ":split<CR>", { desc = "Horizontal split" })

vim.keymap.set("v", "<", "<gv", { desc = "reindent left and select" })
vim.keymap.set("v", ">", ">gv", { desc = "reindent right and select" })

vim.keymap.set("n", "<M-h>", "10<C-w><", { desc = "Resize window(To Left)" })
vim.keymap.set("n", "<M-j>", "10<C-w>-", { desc = "Resize window(To Down)" })
vim.keymap.set("n", "<M-k>", "10<C-w>+", { desc = "Resize window(To Up)" })
vim.keymap.set("n", "<M-l>", "10<C-w>>", { desc = "Resize window(To Right)" })

vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "Copy Selection to clipboard" })
vim.keymap.set({ "n" }, "<leader>Y", [["+Y]], { desc = "Copy Line to clipboard" })

vim.keymap.set({ "x", "n" }, "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll up" })

vim.keymap.set("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment (line)" })
vim.keymap.set("v", "<leader>/", "gc", { remap = true, desc = "Toggle comment (visual)" })
vim.keymap.set(
    "n",
    "<leader>=",
    "O============================================================================================<Esc>gcc",
    { remap = true, desc = "Header" }
)

vim.keymap.set({ "i", "n" }, "<C-Left>", function()
    vim.api.nvim_feedkeys(
        "<cmd>call search('\\<\\<Bar>\\U\\@<=\\u\\<Bar>\\u\\ze\\%(\\U\\&\\>\\@!\\)\\<Bar>\\%^\\','bW')<CR>",
        "n",
        true
    )
end, { desc = "Move to previous word" })

vim.keymap.set({ "i", "n" }, "<C-Right>", function()
    vim.api.nvim_feedkeys(
        "<C-o>:call search('\\<\\<Bar>\\U\\@<=\\u\\<Bar>\\u\\ze\\%(\\U\\&\\>\\@!\\)\\<Bar>\\%$','W')<CR>",
        "n",
        true
    )
end, { desc = "Move to next word" })

vim.keymap.set(
    "c",
    "wsudo",
    "<cmd>lua require'config.utils'.sudo_write()<CR>",
    { desc = "Save file as sudo", silent = true }
)
