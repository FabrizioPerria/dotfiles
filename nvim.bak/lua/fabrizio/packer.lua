-- This file can be loaded by calling `lua require('plugins')` from your init.vim

local vscode = vim.g.vscode == 1
local M = {}
--
function M.setup()
    -- Indicate first time installation
    local packer_bootstrap = false

    -- packer.nvim configuration
    local conf = {
        display = {
            open_fn = function()
                return require("packer.util").float { border = "rounded" }
            end,
        },
    }

    -- Check if packer.nvim is installed
    -- Run PackerCompile if there are changes in this file
    local function packer_init()
        local fn = vim.fn
        local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
        if fn.empty(fn.glob(install_path)) > 0 then
            packer_bootstrap = fn.system {
                "git",
                "clone",
                "--depth",
                "1",
                "https://github.com/wbthomason/packer.nvim",
                install_path,
            }
            vim.cmd [[packadd packer.nvim]]
        end
        vim.cmd "autocmd BufWritePost plugins.lua source <afile> | PackerCompile"
    end

    -- Plugins
    local function plugins(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        use {
            'VonHeikemen/lsp-zero.nvim',
            branch = 'v3.x',

            requires = {
                -- LSP Support
                { 'neovim/nvim-lspconfig' },
                { 'williamboman/mason.nvim' },
                { 'williamboman/mason-lspconfig.nvim' },
                { 'Issafalcon/lsp-overloads.nvim' },

                -- Autocompletion
                { 'llllvvuu/nvim-cmp',                branch = 'feat/above' },
                { 'hrsh7th/cmp-buffer' },
                { 'hrsh7th/cmp-path' },
                { 'saadparwaiz1/cmp_luasnip' },
                { 'hrsh7th/cmp-nvim-lsp' },
                { 'hrsh7th/cmp-nvim-lua' },

                -- Snippets
                { 'L3MON4D3/LuaSnip' },
                { 'rafamadriz/friendly-snippets' },

                -- UI
                { 'onsails/lspkind.nvim' },
                { "ray-x/lsp_signature.nvim" },

                -- Copilot
                { 'zbirenbaum/copilot.lua' },
                { 'zbirenbaum/copilot-cmp' }
            },
            disable = vscode
        }

        use({ "tpope/vim-fugitive", disable = vscode })
        use({ "lewis6991/gitsigns.nvim", disable = vscode })
        use({ "junegunn/gv.vim", disable = vscode })
        use({ 'f-person/git-blame.nvim', disable = vscode })
        use({ "sindrets/diffview.nvim", disable = vscode })

        use({ "aznhe21/actions-preview.nvim", disable = vscode })

        use({ "seblj/nvim-tabline", disable = vscode })
        use({ "lukas-reineke/indent-blankline.nvim", disable = vscode })
        use({ "nvim-lualine/lualine.nvim", disable = vscode })
        use({ "nvim-tree/nvim-web-devicons", disable = vscode })
)

        if packer_bootstrap then
            print "Restart Neovim required after installation!"
            require("packer").sync()
        end
    end
    local packer = require "packer"
    packer.init(conf)
    packer.startup(plugins)
end

return M
