local function open_build_terminal()
    local cmd
    if vim.fn.has("win32") == 1 then
      cmd = [[terminal powershell -NoProfile -Command "$env:MAVEN_OPTS='-Djava.security.manager=allow'; mvn teamcity-configs:generate -f pom.xml"]]
    else
      cmd = "terminal MAVEN_OPTS='-Djava.security.manager=allow' mvn teamcity-configs:generate -f pom.xml"
    end

    vim.cmd("botright 10split")
    vim.cmd(cmd)
    vim.cmd("normal G")

    vim.keymap.set("t", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "q", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
    vim.keymap.set("n", "<Esc>", [[<C-\><C-n>:bd!<CR>]], { buffer = 0, noremap = true, silent = true })
end


vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("wa")
    open_build_terminal()
end, { buffer = true, noremap = true, silent = true })
