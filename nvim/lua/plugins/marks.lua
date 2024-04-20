return {
    {
        'chentoast/marks.nvim',
        lazy = true,
        event = 'BufRead',
        config = function()
            require('marks').setup({
                default_mappings = true,
                default_view = 'relative',
                default_highlight_group = 'Visual',
            })
        end,
    },
}
