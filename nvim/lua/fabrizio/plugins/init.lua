local no_vscode = vim.g.vscode == 0
return {
    { "tpope/vim-fugitive",                  enabled = no_vscode },
    { "junegunn/gv.vim",                     enabled = no_vscode },
    { "christoomey/vim-tmux-navigator",      enabled = no_vscode },
    { 'voldikss/vim-floaterm',               enabled = no_vscode },
    { "nvim-tree/nvim-web-devicons",         enabled = no_vscode },
    { "norcalli/nvim-colorizer.lua",         enabled = no_vscode },
}
