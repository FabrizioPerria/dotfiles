-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd.packadd('packer.nvim')

local vscode = vim.g.vscode == 1
return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use { 'nvim-lua/plenary.nvim', disable = vscode }

    use {
        'nvim-telescope/telescope.nvim',
        requires = {
            { 'nvim-lua/plenary.nvim', disable = vscode }
        },
        disable = vscode
    }

    use {
        "nvim-telescope/telescope-file-browser.nvim",
        requires = {
            { 'nvim-telescope/telescope.nvim', disable = vscode },
            { 'nvim-lua/plenary.nvim',         disable = vscode }
        },
        disable = vscode,
    }

    use {
        "nvim-telescope/telescope-fzf-native.nvim",
        requires = {
            { 'nvim-lua/plenary.nvim',         disable = vscode },
            { 'nvim-telescope/telescope.nvim', disable = vscode }
        },
        disable = vscode,
        run = { 'make' },
    }
    use { 'nvim-telescope/telescope-ui-select.nvim', disable = vscode }
    use { 'debugloop/telescope-undo.nvim', disable = vscode }

    use { 'BurntSushi/ripgrep', disable = vscode, }
    use { 'sharkdp/fd', disable = vscode }

    use({
        'nvim-treesitter/nvim-treesitter',
        disable = vscode,
        run = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    })

    use({
        'nvim-treesitter/nvim-treesitter-textobjects',
        disable = vscode,
        requires = {
            { 'nvim-treesitter/nvim-treesitter', disable = vscode },
            { 'nvim-treesitter/playground',      disable = vscode }
        }
    })
    use({ "nvim-treesitter/nvim-treesitter-context", disable = vscode });

    use { 'jose-elias-alvarez/null-ls.nvim', disable = vscode }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v1.x',
        disable = vscode,
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig',             disable = vscode },
            { 'williamboman/mason.nvim',           disable = vscode },
            { 'williamboman/mason-lspconfig.nvim', disable = vscode },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp',                  disable = vscode },
            { 'hrsh7th/cmp-buffer',                disable = vscode },
            { 'hrsh7th/cmp-path',                  disable = vscode },
            { 'saadparwaiz1/cmp_luasnip',          disable = vscode },
            { 'hrsh7th/cmp-nvim-lsp',              disable = vscode },
            { 'hrsh7th/cmp-nvim-lua',              disable = vscode },

            -- Snippets
            { 'L3MON4D3/LuaSnip',                  disable = vscode },
            { 'rafamadriz/friendly-snippets',      disable = vscode },
        }
    }

    use({
        "mfussenegger/nvim-dap",
        disable = vscode,
        requires = {
            { 'theHamsta/nvim-dap-virtual-text', disable = vscode },
            { 'rcarriga/nvim-dap-ui',            disable = vscode },
        },
    })

    use({ 'Issafalcon/lsp-overloads.nvim', disable = vscode})
    use({ 'jay-babu/mason-nvim-dap.nvim', disable = vscode })
    use({ "mfussenegger/nvim-dap-python", disable = vscode })

    use({ "folke/trouble.nvim", disable = vscode })
    use({ "theprimeagen/harpoon", disable = vscode })
    use({ "theprimeagen/refactoring.nvim", disable = vscode })
    use({ "mbbill/undotree", disable = vscode })

    use({ "tpope/vim-fugitive", disable = vscode })
    use({ "tpope/vim-rhubarb", disable = vscode })
    use({ "lewis6991/gitsigns.nvim", disable = vscode })
    use({ "junegunn/gv.vim", disable = vscode })
    use({ 'f-person/git-blame.nvim', disable = vscode })

    use({ 'prichrd/netrw.nvim' })
    use({ "folke/todo-comments.nvim" })
    use({ "folke/which-key.nvim" })
    use({ "kylechui/nvim-surround" })
    use({ "m4xshen/autoclose.nvim" })
    use({ "christoomey/vim-tmux-navigator", disable = vscode })
    use({ "sindrets/diffview.nvim", disable = vscode })
    use({ "eandrju/cellular-automaton.nvim", disable = vscode })
    use({ "nvim-tree/nvim-web-devicons" })
    use({ "terrortylor/nvim-comment" })
    use({ "lukas-reineke/indent-blankline.nvim", disable = vscode })
    use({ "nvim-lualine/lualine.nvim" })
    use({ "alec-gibson/nvim-tetris", disable = vscode })
    use({ "aznhe21/actions-preview.nvim" })
    use({ 'nvim-telescope/telescope-project.nvim' })
    use({ "akinsho/toggleterm.nvim", disable = vscode })
    use({ "seblj/nvim-tabline", disable = vscode })
    use({ "chrisgrieser/nvim-spider" })
    use({ "zane-/cder.nvim" })

    use({ "norcalli/nvim-colorizer.lua", disable = vscode })
    use({ "folke/tokyonight.nvim", disable = vscode })
    use({ "projekt0n/github-nvim-theme", disable = vscode })
    use({ 'startup-nvim/startup.nvim', disable = vscode})
end)
