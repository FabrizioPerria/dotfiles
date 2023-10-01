-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.0',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }

    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim' }
    }

    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    })

    use({
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = 'nvim-treesitter/nvim-treesitter'
    })

    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason.nvim' },
            { 'williamboman/mason-lspconfig.nvim' },

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
        }
    }

    use({
        "mfussenegger/nvim-dap",
        requires = {
            { 'theHamsta/nvim-dap-virtual-text' },
            { 'rcarriga/nvim-dap-ui' },
        },
    })

    use('jay-babu/mason-nvim-dap.nvim')
    use("mfussenegger/nvim-dap-python")

    use("folke/tokyonight.nvim")
    use("morhetz/gruvbox")
    use("catppuccin/nvim")
    use("rebelot/kanagawa.nvim")
    use("EdenEast/nightfox.nvim")
    use("projekt0n/github-nvim-theme")
    use("rose-pine/neovim")
    use("gmr458/dark_modern.nvim")
    use("shaunsigh/nord.nvim")
    use("navarasu/onedark.nvim")
    use("sainnhe/edge")

    use("folke/trouble.nvim")
    use("theprimeagen/harpoon")
    use("theprimeagen/refactoring.nvim")
    use("mbbill/undotree")

    use("NeogitOrg/neogit")
    use("tpope/vim-fugitive")
    use("tpope/vim-rhubarb")
    use("lewis6991/gitsigns.nvim")
    use("junegunn/gv.vim")

    use("folke/todo-comments.nvim")
    use("nvim-treesitter/nvim-treesitter-context");
    use("kylechui/nvim-surround")
    use("m4xshen/autoclose.nvim")
    use("christoomey/vim-tmux-navigator")
    use("sindrets/diffview.nvim")
    use("folke/zen-mode.nvim")
    use("eandrju/cellular-automaton.nvim")
    use("nvim-tree/nvim-tree.lua")
    use("nvim-tree/nvim-web-devicons")
    use("terrortylor/nvim-comment")
    use('folke/which-key.nvim')
    use("lukas-reineke/indent-blankline.nvim")
end)
