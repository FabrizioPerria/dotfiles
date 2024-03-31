-- vim:formatoptions-=o
return {
    "nvimdev/dashboard-nvim",
    config = function()
        local opts = function()
            local logo = [[
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣤⣶⣶⣶⣶⣦⣤⣤⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣤⣶⣿⣿⠿⠟⠛⠋⠉⠉⠉⠉⠙⠛⠛⠿⢿⣿⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⠿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣷⣦⡀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⢀⣴⣿⡿⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⠻⣿⣦⡀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⣠⣾⡿⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢿⣿⣦⠀⠀⠀⠀
⠀⠀⠀⣴⣿⡟⠁⠀⠀⠀⠀⠀⠀⢀⣤⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⡀⠀⠀
⠀⠀⣼⣿⠏⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣷⡀⠀⠀⠀⠀⠀⠀⠀⣼⣿⣿⣿⣧⠀⠀⠀⠀⠀⠀⠀⠘⣿⣷⠀⠀
⠀⢰⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⢰⣿⣿⣿⣿⣿⡆⠀⠀⠀⠀⠀⠀⠀⠸⣿⣧⠀
⠀⣾⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⣿⣿⣿⣿⣿⡇⠀⠀⠀⠀⠀⠀⠘⣿⣿⣿⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⡄
⢀⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⡟⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇
⢸⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇
⠘⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡇
⠀⢿⣿⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣼⣿⠃
⠀⠸⣿⣧⠀⠀⠀⠀⠀⠰⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⡟⠀⠀⠀⠀⠀⢰⣿⡏⠀
⠀⠀⢻⣿⣆⠀⠀⠀⠀⠀⢻⣿⣿⣿⣶⣶⣤⣤⣤⣀⣀⣀⣀⣤⣤⣤⣴⣶⣿⣿⣿⣿⠁⠀⠀⠀⠀⢠⣿⡿⠁⠀
⠀⠀⠀⢻⣿⣦⠀⠀⠀⠀⠀⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⠀⠀⣠⣿⡿⠁⠀⠀
⠀⠀⠀⠀⠹⣿⣷⡄⠀⠀⠀⠀⠈⠻⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠋⠀⠀⠀⠀⢀⣴⣿⠟⠁⠀⠀⠀
⠀⠀⠀⠀⠀⠈⠻⣿⣦⣄⠀⠀⠀⠀⠈⠙⠻⠿⠿⣿⣿⣿⣿⡿⠿⠟⠋⠁⠀⠀⠀⠀⢀⣴⣿⡿⠋⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠈⠻⢿⣷⣦⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣤⣾⣿⠟⠋⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠻⢿⣿⣷⣦⣤⣤⣀⣀⣀⣀⣀⣀⣠⣤⣴⣶⣿⡿⠟⠋⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠛⠛⠿⠿⠿⠿⠿⠿⠟⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
]]

            logo = string.rep("\n", 4) .. logo .. "\n\n"

            local open_config = function()
                vim.cmd('e ~/.config')
                vim.cmd('cd ~/.config')
            end

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
                        { action = "Telescope live_grep", desc = " Find text", icon = " ", key = "s" },
                        { action = open_config, desc = " Config", icon = " ", key = "c" },
                        { action = 'Telescope project', desc = " Open Project", icon = " ", key = "p" },
                        { action = 'Lazy', desc = "  Lazy", icon = "◉", key = "l" },
                        { action = "qa", desc = " Quit", icon = " ", key = "q" },
                    },
                    footer = function()
                        local utils = require('dashboard.utils')
                        local package_manager_stats = utils.get_package_manager_stats()
                        return {
                            '⚡ Neovim loaded in ' .. package_manager_stats.time .. ' ms',
                            '',
                            '✔ ' ..
                            package_manager_stats.loaded ..
                            ' plugins loaded\t\t⏲ ' .. package_manager_stats.count .. ' plugins installed',
                        }
                    end,
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
}
