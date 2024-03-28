return { {
    "echasnovski/mini.indentscope",
    config = function()
        require('mini.indentscope').setup({
            symbol = "▎",
            options = {
                try_as_border = true
            },
        })
    end
}, {
    "lukas-reineke/indent-blankline.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "folke/tokyonight.nvim", "nvimdev/dashboard-nvim" },
    config = function()
        local highlight = { "RainbowCyan", "RainbowGreen", "RainbowBlue", "RainbowViolet", "RainbowRed", "RainbowYellow",
            "RainbowOrange" }
        local hi_whitespace = { "Whitespace" }
        require("ibl").setup {
            indent = {
                highlight = highlight,
                char = { "▏" }
            },
            scope = {
                enabled = false
            },
            whitespace = {
                highlight = hi_whitespace,
                remove_blankline_trail = false
            },
            exclude = {
                filetypes = { "packer", "dashboard", "help", "Outline", "Trouble" },
                buftypes = { "terminal", "nofile" }
            }
        }
    end
} }
