-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.guicursor =
  "n-v-c:block-blinkwait1000-blinkon100-blinkoff50,i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20"
vim.opt.cursorline = true

vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.textwidth = 140
vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
if vim.fn.has("unix") then
  vim.opt.undodir = vim.fn.getenv("HOME") .. "/.vim/undodir"
else
  vim.opt.undodir = vim.fn.getenv("LOCALAPPDATA") .. "/.vim/undodir"
end
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true
vim.opt.inccommand = "nosplit"

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "140"

vim.opt.foldmethod = "indent"
vim.opt.foldlevelstart = 20
-- vim.opt.encoding="utf-8"
vim.opt.autoindent = true
vim.opt.fileformat = "unix"
vim.opt.listchars = { eol = "_", tab = "→→", trail = "~", space = "·" }

vim.opt.list = true
