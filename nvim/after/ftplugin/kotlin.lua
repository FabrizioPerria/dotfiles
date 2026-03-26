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

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        local file = vim.fn.expand("%:p")
        if file == "" then
            return
        end
        -- only act if file is read-only (i.e. not already checked out)
        if vim.fn.filewritable(file) == 1 then
            return
        end
        local result = vim.fn.system({ "p4", "edit", file })
        local ok = vim.v.shell_error == 0
        vim.notify(
            ok and ("p4: checked out " .. vim.fn.expand("%:t")) or ("p4: " .. result:gsub(" ", "")),
            ok and vim.log.levels.INFO or vim.log.levels.WARN
        )
        if ok then
            -- refresh buffer so nvim sees the file is now writable
            vim.cmd("checktime")
        end
    end,
})

vim.keymap.set("n", "<leader>pd", function()
    local file = vim.fn.expand("%:p")
    local tmp = vim.fn.tempname()
    vim.fn.system({ "p4", "print", "-q", "-o", tmp, file })
    if vim.v.shell_error ~= 0 then
        vim.notify("p4: could not fetch depot version", vim.log.levels.ERROR)
        return
    end
    vim.cmd("vert diffsplit " .. tmp)
    -- mark tmp as the depot side for context
    vim.api.nvim_buf_set_name(0, "depot:" .. vim.fn.expand("%:t"))
end)
