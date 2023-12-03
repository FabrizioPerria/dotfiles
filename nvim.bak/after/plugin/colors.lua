if not vim.g.vscode then
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


    require("tokyonight").setup {
        terminal_colors = true,
        on_highlights = function(hl, colors)
            hl.RainbowRed = { fg = "#891d25" }
            hl.RainbowYellow = { fg = "#936a1b" }
            hl.RainbowBlue = { fg = "#0f5b99" }
            hl.RainbowOrange = { fg = "#784d24" }
            hl.RainbowGreen = { fg = "#4a6d31" }
            hl.RainbowViolet = { fg = "#712288" }
            hl.RainbowCyan = { fg = "#256067" }

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
            hl.CmpItemKindCopilot = { fg = "#6CC644" }
        end
    }

    vim.cmd.colorscheme('tokyonight-moon')

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

    vim.fn.sign_define('DapBreakpoint',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointCondition',
        { text = 'ﳁ', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    vim.fn.sign_define('DapLogPoint', {
        text = '',
        texthl = 'DapLogPoint',
        linehl = 'DapLogPoint',
        numhl = 'DapLogPoint'
    })
    vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = 'DapStopped', numhl = 'DapStopped' })
end
