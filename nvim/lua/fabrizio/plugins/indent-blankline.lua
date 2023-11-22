return { 
    "lukas-reineke/indent-blankline.nvim", 
    enabled = vim.g.vscode == 0,
    config = function()
        require("ibl").setup {
            indent = {
                highlight = highlight,
                -- char = { "⎜" },
            },
            scope = {
                enabled = true,
                priority = 2000,
                highlight = highlight,
                char = { "▎" },
            },
            whitespace = {
                highlight = hi_whitespace,
                remove_blankline_trail = false
            }
        }
    end
}
