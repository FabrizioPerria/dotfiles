require("mini.indentscope").setup({
    symbol = "▎",
    options = { try_as_border = true },
})

require("ibl").setup({
    indent = {
        highlight = { "IndentBlanklineChar" },
        char = { "┆" },
    },
    scope = { enabled = false },
    whitespace = {
        highlight = { "Whitespace" },
        remove_blankline_trail = false,
    },
    exclude = {
        filetypes = { "packer", "dashboard", "help", "Outline", "Trouble" },
        buftypes = { "terminal", "nofile" },
    },
})
