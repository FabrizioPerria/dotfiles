local getHighlight = function()
    -- local rainbow_colors = {
    --     Red = "#891d25",
    --     Yellow = "#936a1b",
    --     Blue = "#0f5b99",
    --     Orange = "#784d24",
    --     Green = "#4a6d31",
    --     Violet = "#712288",
    --     Cyan = "#256067",
    -- }
    -- local highlight = {}
    -- for name, color in pairs(rainbow_colors) do
    --     vim.api.nvim_set_hl(0, "Rainbow" .. name, { fg = color })
    --     table.insert(highlight, "Rainbow" .. name)
    -- end
    -- return highlight
    return { "IndentBlanklineChar" }
end

return {
    {
        "echasnovski/mini.indentscope",
        config = function()
            require("mini.indentscope").setup({
                symbol = "▎",
                options = {
                    try_as_border = true,
                },
            })
        end,
    },
    {
        "lukas-reineke/indent-blankline.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter", "folke/tokyonight.nvim", "nvimdev/dashboard-nvim" },
        event = "VeryLazy",
        config = function()
            local highlight = getHighlight()
            local hi_whitespace = { "Whitespace" }
            require("ibl").setup({
                indent = {
                    highlight = highlight,
                    -- char = { "│" },
                    char = { "┆" },
                    -- char = { "┊" },
                },
                scope = {
                    enabled = false,
                },
                whitespace = {
                    highlight = hi_whitespace,
                    remove_blankline_trail = false,
                },
                exclude = {
                    filetypes = { "packer", "dashboard", "help", "Outline", "Trouble" },
                    buftypes = { "terminal", "nofile" },
                },
            })
        end,
    },
}
