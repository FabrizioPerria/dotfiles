-- Function to open the build terminal
function open_build_terminal_kotlin()
    vim.cmd("botright 10split")
    vim.cmd("terminal ./gradlew build") -- adjust to your build command
    vim.cmd("normal G")

    vim.keymap.set("t", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.kt", "*.kts" },
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:lua open_build_terminal_kotlin()<CR>",
})

local function get_capabilities()
    local capabilities = require("cmp_nvim_lsp").default_capabilities()
    capabilities.offsetEncoding = { "utf-8", "utf-16" }
    capabilities.textDocument = {
        completion = {
            editsNearCursor = true,
        },
    }
    return capabilities
end

local config = {
    cmd = { "kotlin-language-server" },
    filetypes = { "kotlin" },
    root_markers = {
        "pom.xml",
    },
    capabilities = get_capabilities(),
}
vim.lsp.config("kotlin_language_server", config)
return config
