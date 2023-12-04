vim.g.mapleader = " "

vim.keymap.set("n", "J", "mzJ`z", { noremap = true })
vim.keymap.set("x", "J", ":m '>+1<cr>gv=gv", { desc = "Move block down" })
vim.keymap.set("x", "K", ":m '<-2<cr>gv=gv", { desc = "Move lines up" })
vim.keymap.set("n", "Y", "yy", { desc = "Copy full line" })

if not vim.g.vscode then
    vim.keymap.set("n", "<leader>s", ":%s///gI<Left><Left><Left><Left>")
    vim.keymap.set("x", "<leader>s", ":s///gI<Left><Left><Left><Left>")

    vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, { desc = "Format File" })

    vim.keymap.set({ "n", "x" }, "<C-d>", "<C-d>zz", { desc = "Scroll Down and centre" })
    vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll Up and centre" })

    vim.keymap.set({ "i", "n" }, "<C-s>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

    vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "copy selection to system clipboard" })
    vim.keymap.set({ "n" }, "<leader>Y", [["+Y]], { desc = "Copy current line to system clipboard" })
    vim.keymap.set({ "n" }, "<leader>x", "<cmd>!chmod +x %<cr>", { desc = "Make current file executable", silent = true })
    vim.keymap.set({ "n" }, "<leader>w-", [[ 10<C-w>- ]], { desc = "Decrease split's height" })
    vim.keymap.set({ "n" }, "<leader>w=", [[ 10<C-w>+ ]], { desc = "Increase split's height" })
    vim.keymap.set({ "n" }, "<leader>w,", [[ 20<C-w>< ]], { desc = "Decrease split's width" })
    vim.keymap.set({ "n" }, "<leader>w.", [[ 20<C-w>> ]], { desc = "Increase split's width" })
    vim.keymap.set({ "n", "x" }, "<leader>;", vim.lsp.buf.hover, { desc = "Hover" })
    vim.keymap.set({ "n" }, "<leader>rn", vim.lsp.buf.rename, { desc = "rename symbol" })
    vim.keymap.set({ "n", "x" }, "<leader>dd", function()
        if vim.diagnostic.is_disabled() then
            vim.diagnostic.enable()
        else
            vim.diagnostic.disable()
        end
    end, { desc = "Toggle diagnostics" })
    --vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { remap = false, {desc = "Next diagnostic" }) )
    --vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { remap = false, {desc = "Prev diagnostic" }) )
else
    vim.keymap.set({ "n", "x" }, "<C-d>", "<C-d>zz", { desc = "Scroll down and center" })
    vim.keymap.set({ "n", "x" }, "<C-u>", "<C-u>zz", { desc = "Scroll up and center" })

    local vscode = require("vscode-neovim")
    vim.keymap.set({ "n", "x" }, "<leader>s", function() vscode.call("vim-search-and-replace.start") end,
        { desc = "Find in files" })
    vim.keymap.set({ "n" }, "<leader>f", function() vscode.call("editor.action.formatDocument") end,
        { desc = "Format file" })
    vim.keymap.set({ "n" }, "<leader>ff", function() vscode.call("workbench.action.quickOpen") end,
        { desc = "Fuzzy file search" })
    vim.keymap.set({ "n" }, "<leader>fb", function() vscode.call("workbench.action.showAllEditors") end,
        { desc = "Show buffers", silent = false })
    vim.keymap.set({ "n" }, "<leader>fg", function() vscode.call("workbench.view.scm") end,
        { desc = "Fuzzy file search in git repository" })
    vim.keymap.set({ "n" }, "<leader>fs", function() vscode.call("livegrep.search") end, { desc = "Grep search" })
    vim.keymap.set({ "n" }, "<leader>fv", function() vscode.call("workbench.explorer.fileView.focus") end,
        { desc = "Show file browser", silent = false })
    vim.keymap.set({ "n" }, "<leader>fp",
        function() vscode.call("projectManager.listFavoriteProjects#sideBarFavorites") end,
        { desc = "Show marked projects", silent = false })
    vim.keymap.set({ "n" }, "<leader>fpa", function() vscode.call("projectManager.addToFavorites") end,
        { desc = "Add to projects" })

    vim.keymap.set({ "n" }, "<leader>g", function() vscode.call("workbench.view.scm") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gco", function() vscode.call("git.commit") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gg", function() vscode.call("git.pullRebase") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gp", function() vscode.call("git.push") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gm", function() vscode.call("git.merge") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gt", function() vscode.call("git-graph.view") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gch", function() vscode.call("git.checkout") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gsa", function() vscode.call("git.stash") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gsp", function() vscode.call("git.stashPop") end, { desc = " ", silent = false })
    vim.keymap.set({ "n" }, "<leader>gl", function() vscode.call("git.viewHistory") end, { desc = " ", silent = false })
    vim.keymap.set({ "n", "x" }, "<leader>gb", function() vscode.call("gitlens.toggleLineBlame") end,
        { desc = " ", silent = false })

    vim.keymap.set({ "n" }, "<leader>ha", function() vscode.call("vscode-harpoon.addEditor") end, { desc = "Add file", })
    vim.keymap.set({ "n" }, "<leader>hs", function() vscode.call("vscode-harpoon.editorQuickPick") end,
        { desc = "Show files" })
    vim.keymap.set({ "n" }, "<leader>h1", function() vscode.call("vscode-harpoon.gotoEditor1") end,
        { desc = "Open mark 1" })
    vim.keymap.set({ "n" }, "<leader>h2", function() vscode.call("vscode-harpoon.gotoEditor2") end,
        { desc = "Open mark 2" })
    vim.keymap.set({ "n" }, "<leader>h3", function() vscode.call("vscode-harpoon.gotoEditor3") end,
        { desc = "Open mark 3" })
    vim.keymap.set({ "n" }, "<leader>h4", function() vscode.call("vscode-harpoon.gotoEditor4") end,
        { desc = "Open mark 4", })
    vim.keymap.set({ "n" }, "<leader>h5", function() vscode.call("vscode-harpoon.gotoEditor5") end,
        { desc = "Open mark 5", })
    vim.keymap.set({ "n" }, "<leader>h6", function() vscode.call("vscode-harpoon.gotoEditor6") end,
        { desc = "Open mark 6", })
    vim.keymap.set({ "n" }, "<leader>h7", function() vscode.call("vscode-harpoon.gotoEditor7") end,
        { desc = "Open mark 7", })
    vim.keymap.set({ "n" }, "<leader>h8", function() vscode.call("vscode-harpoon.gotoEditor8") end,
        { desc = "Open mark 8", })
    vim.keymap.set({ "n" }, "<leader>h9", function() vscode.call("vscode-harpoon.gotoEditor9") end,
        { desc = "Open mark 9", })

    vim.keymap.set({ "n" }, "<leader>t", function() vscode.call("workbench.action.terminal.focus") end,
        { desc = "Enable Terminal" })
    vim.keymap.set({ "n" }, "<leader>tt", function() vscode.call("todohighlight.listAnnotations") end,
        { desc = "Show todo list" })

    vim.keymap.set({ "n" }, "<leader>vs", function() vscode.call("workbench.action.gotoSymbol") end, { desc = "" })
    vim.keymap.set({ "n" }, "<leader>vr", function() vscode.call("editor.action.goToReferences") end, { desc = "" })
    vim.keymap.set({ "n" }, "<leader>vd", function() vscode.call("editor.action.goToDeclaration") end, { desc = "" })
    vim.keymap.set({ "n" }, "<leader>vi", function() vscode.call("editor.action.goToImplementation") end, { desc = "" })
    vim.keymap.set({ "n" }, "<leader>v;", function() vscode.call("editor.action.showHover") end, { desc = "" })
    vim.keymap.set({ "n" }, "<leader>vrn", function() vscode.action("editor.action.rename") end, { desc = "" })
    vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "copy selection to system clipboard" })
    vim.keymap.set({ "n" }, "<leader>Y", [["+Y]], { desc = "Copy current line to system clipboard" })
    vim.keymap.set({ "n", "x" }, "<leader>/", function() vscode.action("editor.action.commentLine") end,
        { desc = "Comment selection" })
    vim.keymap.set({ "n" }, "<leader>=",
        function()
            local buf = vim.api.nvim_get_current_buf()
            local row = vim.api.nvim_win_get_cursor(0)[1]
            local sep =
            "===================================================================================================="
            vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
            vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
            vscode.action("editor.action.commentLine")
        end, { desc = "Comment selection" })
end
