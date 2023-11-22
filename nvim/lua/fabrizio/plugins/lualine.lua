function GetCurrentWorkingDirectory()
    return vim.fn.getcwd()
end
return { 
    "nvim-lualine/lualine.nvim",
    config = function()
        require('lualine').setup({
            sections = {
                -- lualine_c = { {'filename', path=1} }
                lualine_c = { { "GetCurrentWorkingDirectory()", icons_enabled = true, icon = '' },
                { 'filename', path = 1, icons_enabled = true, icon = '' } }
            }
        })
    end,
    enabled = vim.g.vscode == 0 
}
