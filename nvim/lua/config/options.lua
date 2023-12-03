local options = {
  autoindent = true,
  backup = false,
  breakindent = true,
  clipboard = "unnamedplus",
  colorcolumn = "140",
  cursorline = true,
  expandtab = true,
  fileformat = "unix",
  --  fillchars = { foldclose = " ", fold = " ", eob = " " },
  foldmethod = "indent",
  foldlevelstart = 20,
  guicursor = "n-v-c:block-blinkwait1000-blinkon100-blinkoff50,i-ci-ve:ver25-blinkwait300-blinkon200-blinkoff150,r-cr-o:hor20",
  hlsearch = false,
  incsearch = true,
  inccommand = "nosplit",
  list = true,
  listchars = { eol = "↲", tab = "▸ ", trail = "·", space = "·" },
  mouse = "a",
  nrformats = { "alpha", "octal", "hex" },
  number = true,
  numberwidth = 3,
  relativenumber = true,
  scrolloff = 8,
  shiftround = true,
  shiftwidth = 4,
  shortmess = "aToO",
  showbreak = "↪",
  showmatch = true,
  showmode = true,
  signcolumn = "yes",
  smartcase = true,
  smartindent = true,
  softtabstop = 4,
  splitbelow = true,
  splitright = true,
  swapfile = false,
  tabstop = 4,
  termguicolors = true,
  textwidth = 140,
  timeoutlen = 450,
  undofile = true,
  updatetime = 50,
  virtualedit = { "block" },
  wildmode = { "list", "longest" },
  wrap = true,
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

vim.opt.isfname:append("@-@")
if vim.fn.has("unix") then
  vim.opt.undodir = vim.fn.getenv("HOME") .. "/.vim/undodir"
else
  vim.opt.undodir = vim.fn.getenv("LOCALAPPDATA") .. "/.vim/undodir"
end

vim.cmd([[filetype plugin indent on]])

vim.g.bullets_enabled_file_types = {
  "gitcommit",
  "markdown",
  "scratch",
  "text",
  "wiki",
}
