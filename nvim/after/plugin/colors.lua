local highlight = {
    "RainbowRed",
    "RainbowYellow",
    "RainbowBlue",
    "RainbowOrange",
    "RainbowGreen",
    "RainbowViolet",
    "RainbowCyan",
}

local hi_whitespace = {
    "CursorColumn",
    "Whitespace"
}

vim.keymap.set('n', '<leader>co', ':ColorizerToggle<CR>')

require("tokyonight").setup {
    terminal_colors = true,
    on_highlights = function(hl, colors)
        hl.RainbowRed = { fg = "#E06C75" }
        hl.RainbowYellow = { fg = "#E5C07B" }
        hl.RainbowBlue = { fg = "#61AFEF" }
        hl.RainbowOrange = { fg = "#D19A66" }
        hl.RainbowGreen = { fg = "#98C379" }
        hl.RainbowViolet = { fg = "#C678DD" }
        hl.RainbowCyan = { fg = "#56B6C2" }

        hl.DiffText = { bg = "#373640", fg = "#e0af68" }
        hl.DiffAdd = { bg = "#233745", fg = "#1abc9c" }
        hl.DiffChange = { bg = colors.none }
        hl.DiffDelete = { bg = "#362c3d", fg = "#db4b4b" }
        hl.DiffDelete = { bg = "#360000", fg = "#db4b4b" }

        hl.DapBreakpoint = { ctermbg = 0, fg = '#993939', bg = '#31353f' }
        hl.DapLogPoint = { ctermbg = 0, fg = '#61afef', bg = '#31353f' }
        hl.DapStopped = { ctermbg = 0, fg = '#98c379', bg = '#31353f' }
        hl.LineNr = { fg = "#6f99bb", }
        hl.CursorLineNr = { bg = "#697fff", fg = "#ffffff" }
    end,
}
vim.cmd.colorscheme('tokyonight-storm')

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
