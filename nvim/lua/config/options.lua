vim.opt.guicursor =
    "n-v-c:block-blinkwait1000-blinkon100-blinkoff50,i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20"
vim.opt.cursorline = true

vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.textwidth = 120
vim.opt.wrap = true

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false
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

vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.showmatch = true
vim.opt.matchtime = 2
vim.opt.lazyredraw = true
vim.opt.isfname:append("@-@")

vim.opt.hidden = true
vim.opt.errorbells = false
vim.opt.backspace = "indent,eol,start"
vim.opt.iskeyword:append("-")
vim.opt.path:append("**")
vim.opt.selection = "exclusive"

vim.opt.autoread = true
vim.opt.autowrite = false

vim.opt.updatetime = 10

vim.opt.colorcolumn = "120"

vim.opt.foldmethod = "expr"
vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldlevel = 99
vim.opt.encoding = "utf-8"
vim.opt.autoindent = true
vim.opt.fileformat = "unix"
vim.opt.listchars = {
    eol = "_",
    tab = "→→",
    trail = "~",
    space = "·",
}

vim.opt.list = true

vim.opt.mouse = ""

vim.g.gitblame_delay = 0
vim.g.python3_host_prog = vim.fn.system("which python3.12"):gsub("\n", "")
