-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local vscode = vim.g.vscode == 1
--
local packerpath = vim.fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
print(packerpath)
if not vim.loop.fs_stat(packerpath) then
  vim.fn.system({
    "git",
    "clone",
    "--depth=1",
    "https://github.com/wbthomason/packer.nvim",
    packerpath,
  })
end

--vim.opt.rtp:prepend(packerpath)

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } }, disable = vscode }
    use { "nvim-telescope/telescope-file-browser.nvim", requires = { { 'nvim-telescope/telescope.nvim' }, }, disable =
        vscode }
    use { "nvim-telescope/telescope-fzf-native.nvim", requires = { { 'nvim-telescope/telescope.nvim' } }, run = { 'make' }, disable =
        vscode }
    use { 'nvim-telescope/telescope-ui-select.nvim', requires = { { 'nvim-telescope/telescope.nvim' } }, disable = vscode }
    use { 'nvim-telescope/telescope-project.nvim', requires = { { 'nvim-telescope/telescope.nvim' } }, disable = vscode }
    use { 'debugloop/telescope-undo.nvim', requires = { { 'nvim-telescope/telescope.nvim' } }, disable = vscode }
    use { 'nvim-telescope/telescope-packer.nvim', requires = { { 'nvim-telescope/telescope.nvim' } }, disable = vscode }
    use { "nvim-telescope/telescope-dap.nvim", requires = { { 'nvim-telescope/telescope.nvim' } }, disable = vscode }

    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    })
    use({
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = { { 'nvim-treesitter/nvim-treesitter', }, { 'nvim-treesitter/playground' } },
        after = "nvim-treesitter",
    })
    use({ "nvim-treesitter/nvim-treesitter-context" });

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',

        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },
            { 'Issafalcon/lsp-overloads.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        },
        disable = vscode
    }
    use({ 'zbirenbaum/copilot.lua', disable = vscode })
    use({ 'onsails/lspkind.nvim', disable = vscode })
    use({ "ray-x/lsp_signature.nvim", disable = vscode })

    use({
        "mfussenegger/nvim-dap",
        requires = { { 'theHamsta/nvim-dap-virtual-text' }, { 'rcarriga/nvim-dap-ui' }, },
        disable = vscode
    })
    use({ 'jay-babu/mason-nvim-dap.nvim', disable = vscode })
    use({ "mfussenegger/nvim-dap-python", disable = vscode })

    use({ "tpope/vim-fugitive", disable = vscode })
    use({ "lewis6991/gitsigns.nvim", disable = vscode })
    use({ "junegunn/gv.vim", disable = vscode })
    use({ 'f-person/git-blame.nvim', disable = vscode })
    use({ "sindrets/diffview.nvim", disable = vscode })

    use({ "theprimeagen/harpoon", disable = vscode })
    use({ "theprimeagen/refactoring.nvim", disable = vscode })
    use({ "folke/todo-comments.nvim", disable = vscode })
    use({ "folke/which-key.nvim" })
    use({ "kylechui/nvim-surround" })
    use({ "m4xshen/autoclose.nvim" })
    use({ "christoomey/vim-tmux-navigator", disable = vscode })
    use({ "eandrju/cellular-automaton.nvim", disable = vscode })
    use({ "terrortylor/nvim-comment", disable = vscode })
    use({ "aznhe21/actions-preview.nvim", disable = vscode })
    use({ 'voldikss/vim-floaterm', disable = vscode })

    use({ "folke/trouble.nvim", disable = vscode })
    use({ "seblj/nvim-tabline", disable = vscode })
    use({ "lukas-reineke/indent-blankline.nvim", disable = vscode })
    use({ "nvim-lualine/lualine.nvim", disable = vscode })
    use({ "nvim-tree/nvim-web-devicons", disable = vscode })
    use({ "norcalli/nvim-colorizer.lua", disable = vscode })
    use({ "folke/tokyonight.nvim", disable = vscode })
    use({ 'startup-nvim/startup.nvim', disable = vscode })
    use({ 'prichrd/netrw.nvim', disable = vscode })
end)
