-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { 'nvim-telescope/telescope.nvim', requires = { { 'nvim-lua/plenary.nvim' } }, }
    use { "nvim-telescope/telescope-file-browser.nvim", requires = { { 'nvim-telescope/telescope.nvim' }, }, }
    use { "nvim-telescope/telescope-fzf-native.nvim", requires = { { 'nvim-telescope/telescope.nvim' } }, run = { 'make' }, }
    use { 'nvim-telescope/telescope-ui-select.nvim' }
    use({ 'nvim-telescope/telescope-project.nvim' })
    use { 'debugloop/telescope-undo.nvim' }
    use { 'nvim-telescope/telescope-packer.nvim' }
    use({ "nvim-telescope/telescope-dap.nvim" })

    use({
        'nvim-treesitter/nvim-treesitter',
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    })
    use({
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = { { 'nvim-treesitter/nvim-treesitter' }, { 'nvim-treesitter/playground' } }
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
        }
    }
    use({ 'zbirenbaum/copilot.lua' })
    use({ 'onsails/lspkind.nvim' })

    use({ "mfussenegger/nvim-dap", requires = { { 'theHamsta/nvim-dap-virtual-text' }, { 'rcarriga/nvim-dap-ui' }, }, })
    use({ 'jay-babu/mason-nvim-dap.nvim' })
    use({ "mfussenegger/nvim-dap-python" })

    use({ "tpope/vim-fugitive" })
    use({ "lewis6991/gitsigns.nvim" })
    use({ "junegunn/gv.vim" })
    use({ 'f-person/git-blame.nvim' })
    use({ "sindrets/diffview.nvim" })

    use({ "theprimeagen/harpoon" })
    use({ "theprimeagen/refactoring.nvim" })
    use({ "folke/todo-comments.nvim" })
    use({ "folke/which-key.nvim" })
    use({ "kylechui/nvim-surround" })
    use({ "m4xshen/autoclose.nvim" })
    use({ "christoomey/vim-tmux-navigator" })
    use({ "eandrju/cellular-automaton.nvim" })
    use({ "terrortylor/nvim-comment" })
    use({ "aznhe21/actions-preview.nvim" })
    use({ 'voldikss/vim-floaterm' })

    use({ "folke/trouble.nvim" })
    use({ "seblj/nvim-tabline" })
    use({ "lukas-reineke/indent-blankline.nvim" })
    use({ "nvim-lualine/lualine.nvim" })
    use({ "nvim-tree/nvim-web-devicons" })
    use({ "norcalli/nvim-colorizer.lua" })
    use({ "folke/tokyonight.nvim" })
    use({ 'startup-nvim/startup.nvim' })
    use({ 'prichrd/netrw.nvim' })
end)
