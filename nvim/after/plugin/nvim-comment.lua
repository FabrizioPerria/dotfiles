require('nvim_comment').setup({
    marker_padding = true,
    comment_empty = false,
    comment_empty_trim_whitespace = true,
})

vim.keymap.set({ "n", "v" }, "<leader>/", ':CommentToggle<CR>')
