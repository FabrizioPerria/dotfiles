local refresh = vim.api.nvim_create_augroup("refresh", {
    clear = true,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*" },
    group = refresh,
    command = "set formatoptions-=cro",
})

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "dashboard" },
    group = refresh,

    command = "lua vim.b.miniindentscope_disable=true",
})

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "CMakeLists.txt" },
    group = refresh,
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:FloatermNew --autoclose=0 ./build.sh<CR>",
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
        vim.cmd("norm G")
        vim.cmd([[nnoremap <buffer> <Esc> :bd!<CR>]])
    end,
})

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function()
        vim.keymap.set("n", "<leader>a", function()
            require("actions-preview").code_actions()
        end, {})
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", {})
        vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", {})
        vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", {})
        vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", {})
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", {})
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", {})
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", {})
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", {})
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", {})
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {})
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", {})

        vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", {})
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", {})
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", {})
    end,
})
