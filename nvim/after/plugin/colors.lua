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

local hooks = require "ibl.hooks"
hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
    vim.api.nvim_set_hl(0, "RainbowRed", { fg = "#E06C75" })
    vim.api.nvim_set_hl(0, "RainbowYellow", { fg = "#E5C07B" })
    vim.api.nvim_set_hl(0, "RainbowBlue", { fg = "#61AFEF" })
    vim.api.nvim_set_hl(0, "RainbowOrange", { fg = "#D19A66" })
    vim.api.nvim_set_hl(0, "RainbowGreen", { fg = "#98C379" })
    vim.api.nvim_set_hl(0, "RainbowViolet", { fg = "#C678DD" })
    vim.api.nvim_set_hl(0, "RainbowCyan", { fg = "#56B6C2" })
end)

require("ibl").setup {
    indent = { highlight = highlight },
    whitespace = {
        highlight = hi_whitespace,
        remove_blankline_trail = false
    },
    scope = {
        enabled = false,
        highlight = highlight
    }
}

vim.keymap.set('n', '<leader>co', ':ColorizerToggle<CR>')

require("tokyonight").setup {
    terminal_colors = true,
    on_highlights = function(hl, colors)
        hl.DiffText = { bg = "#373640", fg = "#e0af68" }
        hl.DiffAdd = { bg = "#233745", fg = "#1abc9c" }
        hl.DiffChange = { bg = colors.none }
        hl.DiffDelete = { bg = "#362c3d", fg = "#db4b4b" }
        hl.DiffDelete = { bg = "#360000", fg = "#db4b4b" }

        hl.LineNr = { fg = "#6f99bb", }
        hl.CursorLineNr = { bg = "#637bff", fg = "#ffffff" }
    end,
}
vim.cmd.colorscheme('tokyonight-storm')
--
-- vim.cmd.colorscheme('github_dark_dimmed')
-- require('github-theme').setup({
--     groups = {
--         all = {
--             DiffText = { bg = "#373640", fg = "#e0af68" },
--             DiffAdd = { bg = "#233745", fg = "#1abc9c" },
--             DiffDelete = { bg = "#362c3d", fg = "#db4b4b" }
--         }
--     }
-- })
