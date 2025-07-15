vim.g.mapleader = " "
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
vim.cmd("colorscheme unokai")
vim.cmd("highlight Nontext guifg=#454545")

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
vim.keymap.set("n", "Y", "yy", { desc = "Yank line" })
vim.keymap.set("n", "<leader>fe", ":E<CR>", { desc = "Explore" })
vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "Copy Selection to clipboard" })
vim.keymap.set({ "n" }, "<leader>Y", [["+Y]], { desc = "Copy Line to clipboard" })

vim.keymap.set({ "x", "n" }, "<C-d>", "<C-d>zz", { desc = "Scroll down" })
vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll up" })

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

vim.keymap.set({ "i", "n" }, "<C-Left>", function()
	vim.api.nvim_feedkeys(
		"<C-o>:call search('\\<\\<Bar>\\U\\@<=\\u\\<Bar>\\u\\ze\\%(\\U\\&\\>\\@!\\)\\<Bar>\\%^','bW')<CR>",
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
