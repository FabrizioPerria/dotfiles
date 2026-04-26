local function open_build_terminal()
    vim.cmd("botright 10split")
    vim.cmd("terminal MAVEN_OPTS='-Djava.security.manager=allow' mvn teamcity-configs:generate -f pom.xml")
    vim.cmd("normal G")

    vim.keymap.set("t", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
end

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("wa")
    open_build_terminal()
end, { buffer = true, noremap = true, silent = true })
