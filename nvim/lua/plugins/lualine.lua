function GetCurrentWorkingDirectory()
    return vim.fn.getcwd()
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
        sections = {
            lualine_c = {
                { "GetCurrentWorkingDirectory()", icons_enabled = true, icon = "" },
                { "filename", path = 1, icons_enabled = true, icon = "" },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress", "location" },
            lualine_z = { "diagnostics" },
        },
    },
}
