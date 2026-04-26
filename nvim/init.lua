require("config.keymaps")
require("config.options")

vim.pack.add({
    -- Colorscheme
    "https://github.com/folke/tokyonight.nvim",
    "https://github.com/norcalli/nvim-colorizer.lua",
    "https://github.com/chentoast/marks.nvim",

    -- LSP
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mfussenegger/nvim-jdtls",
    "https://github.com/seblyng/roslyn.nvim",

    -- Mason
    "https://github.com/williamboman/mason.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",

    -- Telescope
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
    "https://github.com/nvim-telescope/telescope-file-browser.nvim",
    { src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "https://github.com/nvim-telescope/telescope-live-grep-args.nvim",
    "https://github.com/nvim-telescope/telescope-project.nvim",
    "https://github.com/nvim-telescope/telescope-dap.nvim",
    "https://github.com/debugloop/telescope-undo.nvim",
    "https://github.com/nvim-telescope/telescope-ui-select.nvim",
    "https://github.com/aznhe21/actions-preview.nvim",

    -- Treesitter
    { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
    "https://github.com/nvim-treesitter/nvim-treesitter-textobjects",

    -- DAP
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/theHamsta/nvim-dap-virtual-text",
    "https://github.com/leoluz/nvim-dap-go",
    "https://github.com/mfussenegger/nvim-dap-python",
    "https://github.com/Cliffback/netcoredbg-macOS-arm64.nvim",
    "https://github.com/TheLeoP/powershell.nvim",

    -- Git
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/FabijanZulj/blame.nvim",

    -- Test
    "https://github.com/nvim-neotest/neotest",
    "https://github.com/nvim-neotest/neotest-go",
    "https://github.com/nvim-neotest/neotest-python",
    "https://github.com/Issafalcon/neotest-dotnet",
    "https://github.com/fabrizioperria/neotest-jdtls",
    "https://github.com/alfaix/neotest-gtest",
    "https://github.com/antoinemadec/FixCursorHold.nvim",

    -- UI
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/nvim-tree/nvim-web-devicons",
    "https://github.com/lukas-reineke/indent-blankline.nvim",
    "https://github.com/echasnovski/mini.indentscope",

    -- Navigation
    { src = "https://github.com/theprimeagen/harpoon", version = "87b1a3506211538f460786c23f98ec63ad9af4e5" },
    "https://github.com/christoomey/vim-tmux-navigator",

    -- Editing
    "https://github.com/kylechui/nvim-surround",
    "https://github.com/folke/ts-comments.nvim",
    "https://github.com/folke/which-key.nvim",
})

require("plugins.colorscheme")
require("plugins.lsp")
require("plugins.mason")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.dap")
require("plugins.git")
require("plugins.test")
require("plugins.lualine")
require("plugins.indent")
require("plugins.harpoon")
require("plugins.surround")
require("plugins.comments")
require("plugins.whichkey")
require("plugins.tmux")
