-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "J", "mzJ`z", { noremap = true })
--
vim.keymap.set("n", "<leader>s", ":%s///gI<Left><Left><Left><Left>")
vim.keymap.set("x", "<leader>s", ":s///gI<Left><Left><Left><Left>")

vim.keymap.set("x", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("x", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "Y", "yy")
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]])
vim.keymap.set({ "n" }, "<leader>Y", [["+Y]])

vim.keymap.set({ "x", "n" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz")
vim.keymap.set("n", "<leader>=", function()
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1]
  local sep = "===================================================================================================="
  vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
  require("mini.comment").toggle_lines(row + 1, row + 1)
  vim.api.nvim_win_set_cursor(0, { row + 2, 0 })
end)
