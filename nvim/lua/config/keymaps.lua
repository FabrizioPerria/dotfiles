vim.g.mapleader = " "

vim.keymap.set("n", "J", "mzJ`z", { noremap = true })

if not vim.g.vscode then
  vim.keymap.set("n", "<leader>s", ":%s///gI<Left><Left><Left><Left>")
  vim.keymap.set("x", "<leader>s", ":s///gI<Left><Left><Left><Left>")

  vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format File" })

  vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move block down" })
  vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })
  vim.keymap.set("n", "Y", "yy", { desc = "Copy full line" })

  vim.keymap.set({ "n", "x" }, "<C-d>", "<C-d>zz", { desc = "Scroll Down and centre" })
  vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll Up and centre" })

  vim.keymap.set({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

  vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "copy selection to system clipboard" })
  vim.keymap.set({ "n" }, "<leader>Y", [["+Y]], { desc = "Copy current line to system clipboard" })
  vim.keymap.set({ "n" }, "<leader>x", "<cmd>!chmod +x %<cr>", { desc = "Make current file executable", silent = true })
  vim.keymap.set({ "n" }, "<leader>w-", [[ 10<C-w>- ]], { desc = "Decrease split's height" })
  vim.keymap.set({ "n" }, "<leader>w=", [[ 10<C-w>+ ]], { desc = "Increase split's height" })
  vim.keymap.set({ "n" }, "<leader>w,", [[ 20<C-w>< ]], { desc = "Decrease split's width" })
  vim.keymap.set({ "n" }, "<leader>w.", [[ 20<C-w>> ]], { desc = "Increase split's width" })
  vim.keymap.set({ "n", "x" }, "<leader>;", vim.lsp.buf.hover, { desc = "Hover" })
  vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename, { desc = "rename symbol" })
  vim.keymap.set({ "n", "x" }, "<leader>dd", function()
    if vim.diagnostic.is_disabled() then
      vim.diagnostic.enable()
    else
      vim.diagnostic.disable()
    end
  end, { desc = "Toggle diagnostics" })
  --vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { remap = false, desc = "Next diagnostic" })
  --vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { remap = false, desc = "Prev diagnostic" })
end
