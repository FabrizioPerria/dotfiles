if vim.g.vscode then
    vim.keymap.set({ "v", "n" }, "<leader>a", ":call VSCodeNotify('editor.action.quickFix')<CR>")
else
    vim.keymap.set({ "v", "n" }, "<leader>a", require("actions-preview").code_actions, {desc='Show code actions'})
end
