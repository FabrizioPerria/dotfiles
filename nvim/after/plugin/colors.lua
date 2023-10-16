if not vim.g.vscode then
    -- vim.cmd.colorscheme('rose-pine')
    --
    -- vim.cmd.colorscheme('gruvbox')

    -- vim.cmd.colorscheme('catppuccin')

    -- vim.cmd.colorscheme('kanagawa')

    -- vim.cmd.colorscheme('carbonfox')

    vim.cmd.colorscheme('github_dark_dimmed')
    require('github-theme').setup({
        groups = {
            all = {
                DiffText = { bg = '#333027', fg = '#c69026' },
                DiffChanged = { bg = '#333027', fg = '#c69026' },
                DiffChange = { bg = '#292e36', fg = '#adbac7' }
            }
        }
    })

    -- require('tokyonight').setup()
    -- vim.cmd.colorscheme('tokyonight')

    -- require('dark_modern').setup()
    -- vim.cmd.colorscheme('dark_modern')
end
