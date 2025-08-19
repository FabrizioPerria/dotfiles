-- Function to open the build terminal
function open_build_terminal()
    vim.cmd("botright 10split") -- Open a split at the bottom
    vim.cmd("terminal ./build.sh") -- Open terminal and run script
    vim.cmd("normal G") -- Scroll to bottom of terminal output

    -- In terminal mode, map <Esc> to close the terminal and the split
    vim.keymap.set("t", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("t", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
end

vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
    pattern = { "*.cpp", "*.hpp" },
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:lua open_build_terminal()<CR>",
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
    cmd = { "clangd" },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
        ".git",
    },
    capabilities = get_capabilities(),
}
vim.lsp.config("clangd", config)
return config
