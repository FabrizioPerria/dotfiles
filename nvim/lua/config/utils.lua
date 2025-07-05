M = {}

M.fast_event_aware_notify = function(msg, level, opts)
    if vim.in_fast_event() then
        vim.schedule(function()
            vim.notify(msg, level, opts)
        end)
    else
        vim.notify(msg, level, opts)
    end
end

M.err = function(msg)
    M.fast_event_aware_notify(msg, vim.log.levels.ERROR, {})
end

M.sudo_exec = function(cmd, print_output)
    vim.fn.inputsave()
    local password = vim.fn.inputsecret("Password: ")
    vim.fn.inputrestore()
    if not password or #password == 0 then
        M.err("Invalid password, sudo aborted")
        return false
    end
    local out = vim.fn.system(string.format("sudo -p '' -S %s", cmd), password)
    if vim.v.shell_error ~= 0 then
        print("\r\n")
        M.err(out)
        return false
    end
    if print_output then
        print("\r\n", out)
    end
    return true
end

M.sudo_write = function(tmpfile, filepath)
    if not tmpfile then
        tmpfile = vim.fn.tempname()
    end
    if not filepath then
        filepath = vim.fn.expand("%")
    end
    if not filepath or #filepath == 0 then
        M.err("E32: No file name")
        return
    end
    -- `bs=1048576` is equivalent to `bs=1M` for GNU dd or `bs=1m` for BSD dd
    -- Both `bs=1M` and `bs=1m` are non-POSIX
    local cmd = string.format("dd if=%s of=%s bs=1048576", vim.fn.shellescape(tmpfile), vim.fn.shellescape(filepath))
    -- no need to check error as this fails the entire function
    vim.api.nvim_exec2(string.format("write! %s", tmpfile), { output = true })
    if M.sudo_exec(cmd) then
        -- refreshes the buffer and prints the "written" message
        vim.cmd.checktime()
        -- exit command mode
        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", true)
    end
    vim.fn.delete(tmpfile)
end

M.is_java_project = function()
    local function find_file_in_ancestors(filename, path)
        path = path or vim.fn.getcwd()
        if vim.fn.glob(path .. "/" .. filename) ~= "" then
            return true
        end
        local parent = vim.fn.fnamemodify(path, ":h")
        if parent == path then
            return false
        end
        return find_file_in_ancestors(filename, parent)
    end

    local java_files = { "build.gradle", "pom.xml", "src/main/java", "settings.gradle" }
    for _, file in ipairs(java_files) do
        if find_file_in_ancestors(file) then
            return true
        end
    end
    return false
end

M.find_python_executable = function()
    local python_executable = vim.fn.exepath("python3")
    if python_executable == "" then
        python_executable = vim.fn.exepath("python")
    end
    if python_executable == "" then
        M.err("Python executable not found")
        return
    end
    return python_executable
end

return M
