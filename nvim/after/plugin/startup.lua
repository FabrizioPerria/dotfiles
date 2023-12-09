if not vim.g.vscode then
    local opts = function()
        local logo = [[
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░                ░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░░░░░░░░░░░░░
░░░░░░░░░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░░░░░░░░░░░
░░░░░░░░░░  ░░░░░░░░░    ░░░░░░░░░░    ░░░░░░░░░  ░░░░░░░░░░
░░░░░░░░░  ░░░░░░░░░      ░░░░░░░░      ░░░░░░░░░  ░░░░░░░░░
░░░░░░░░░  ░░░░░░░░░      ░░░░░░░░      ░░░░░░░░░  ░░░░░░░░░
░░░░░░░░░  ░░░░░░░░░░    ░░░░░░░░░░    ░░░░░░░░░░  ░░░░░░░░░
░░░░░░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░░░░░░░░
░░░░░░░░░  ░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░  ░░░░░░░░░
░░░░░░░░░░  ░░░░░░ ░░░░░░░░░░░░░░░░░░░░░░ ░░░░░░  ░░░░░░░░░░
░░░░░░░░░░░  ░░░░░░    ░░░░░░░░░░░░░░    ░░░░░░  ░░░░░░░░░░░
░░░░░░░░░░░░░  ░░░░░░░                ░░░░░░░  ░░░░░░░░░░░░░
░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░░░░░░░░░░   ░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░    ░░░░░░░░░░░░░░░░    ░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░                ░░░░░░░░░░░░░░░░░░░░░░
░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░░

    ]]

        logo = string.rep("\n", 8) .. logo .. "\n\n"

        local opts = {
            theme = "doom",
            hide = {
                -- this is taken care of by lualine
                -- enabling this messes up the actual laststatus setting after loading a file
                statusline = false,

            },
            config = {
                header = vim.split(logo, "\n"),
                -- stylua: ignore
                center = {
                    { action = "Telescope find_files", desc = " Find file", icon = "󰱼 ", key = "f" },
                    { action = "ene | startinsert", desc = " New file", icon = " ", key = "n" },
                    { action = "Telescope oldfiles", desc = " Recent files", icon = " ", key = "r" },
                    { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "g" },
                    { action = "e ~/.config", desc = " Config", icon = " ", key = "c" },
                    { action = 'Telescope project', desc = " Open Project", icon = " ", key = "p" },
                    { action = "qa", desc = " Quit", icon = " ", key = "q" },
                },
                -- footer = function()
                --     return {  "⚡ Neovim loaded " }
                -- end,
            },
        }

        for _, button in ipairs(opts.config.center) do
            button.desc = button.desc .. string.rep(" ", 43 - #button.desc)
            button.key_format = "  %s"
        end

        return opts
    end
    require('dashboard').setup(opts())
end
