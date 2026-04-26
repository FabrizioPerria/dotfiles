local function p4_notify(cmd, args)
    local result = vim.fn.system(vim.list_extend({ "p4", cmd }, args or {}))
    local ok = vim.v.shell_error == 0
    vim.notify(
        ok and ("p4 " .. cmd .. ": " .. (args and args[1] and vim.fn.fnamemodify(args[1], ":t") or ""))
            or ("p4: " .. result:gsub("%s+", " ")),
        ok and vim.log.levels.INFO or vim.log.levels.WARN
    )
    return ok, result
end

local function p4_scratch_buf(lines, height)
    local buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_option(buf, "buftype", "nofile")
    vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    vim.api.nvim_buf_set_option(buf, "modifiable", false)
    vim.cmd("botright " .. math.min(height or #lines + 2, 20) .. "split")
    vim.api.nvim_win_set_buf(0, buf)
    return buf
end

local function p4_buf_close_keys(buf, desc)
    vim.keymap.set("n", "q", "<cmd>bd!<CR>", { buffer = buf, noremap = true, silent = true, desc = desc or "close" })
    vim.keymap.set("n", "<Esc>", "<cmd>bd!<CR>", { buffer = buf, noremap = true, silent = true })
end

local function p4_current_depot()
    local current = vim.fn.expand("%:p")
    local where = vim.fn.system({ "p4", "where", current })
    return vim.v.shell_error == 0 and vim.trim(where:match("^(//[^%s]+)") or "") or nil
end

local function p4_resolve_local(depot)
    local out = vim.fn.system({ "p4", "where", depot })
    return vim.trim(out:match("^//[^%s]+%s+//[^%s]+%s+([^%s\n]+)") or "")
end

local function p4_open_diff_against_depot(depot, on_close)
    local tmp = vim.fn.tempname()
    vim.fn.system({ "p4", "print", "-q", "-o", tmp, depot })
    if vim.v.shell_error ~= 0 then
        vim.notify("p4: could not fetch depot version", vim.log.levels.ERROR)
        return false
    end
    local fpath = p4_resolve_local(depot)
    if fpath == "" then
        vim.notify("p4: could not resolve local path", vim.log.levels.WARN)
        return false
    end
    vim.cmd("edit " .. vim.fn.fnameescape(fpath))
    local file_win = vim.api.nvim_get_current_win()
    vim.cmd("diffthis")
    vim.cmd("vert diffsplit " .. vim.fn.fnameescape(tmp))
    vim.api.nvim_buf_set_name(0, "depot:" .. vim.fn.fnamemodify(depot, ":t"))
    local depot_buf = vim.api.nvim_get_current_buf()

    local function close_diff()
        vim.cmd("diffoff!")
        vim.api.nvim_buf_delete(depot_buf, { force = true })
        if vim.api.nvim_win_is_valid(file_win) then
            vim.api.nvim_win_close(file_win, true)
        end
        if on_close then
            on_close()
        end
    end

    for _, b in ipairs({ depot_buf, vim.api.nvim_win_get_buf(file_win) }) do
        vim.keymap.set("n", "q", close_diff, { buffer = b, noremap = true, silent = true, desc = "p4 close diff" })
        vim.keymap.set("n", "<Esc>", close_diff, { buffer = b, noremap = true, silent = true })
    end
    return true
end

local function p4_opened_lines()
    local result = vim.fn.system({ "p4", "opened" })
    if vim.v.shell_error ~= 0 or vim.trim(result) == "" then
        return nil, nil
    end
    local depot_current = p4_current_depot()
    local lines, depot_paths = {}, {}
    for line in result:gmatch("[^\n]+") do
        local depot = vim.trim(line:match("^(//.-) *#") or "")
        local marker = (depot_current and depot ~= "" and depot:lower() == depot_current:lower()) and "[this file]"
            or "           "
        table.insert(lines, marker .. " " .. line)
        table.insert(depot_paths, depot)
    end
    return lines, depot_paths
end

local function p4_reopen_buf(buf, lines, row)
    vim.api.nvim_buf_set_option(buf, "bufhidden", "wipe")
    vim.cmd("botright " .. math.min(#lines + 2, 20) .. "split")
    vim.api.nvim_win_set_buf(0, buf)
    vim.api.nvim_win_set_cursor(0, { row, 0 })
end

vim.keymap.set("n", "<leader>pd", function()
    local file = vim.fn.expand("%:p")
    local tmp = vim.fn.tempname()
    vim.fn.system({ "p4", "print", "-q", "-o", tmp, file })
    if vim.v.shell_error ~= 0 then
        vim.notify("p4: could not fetch depot version", vim.log.levels.ERROR)
        return
    end
    local orig_win = vim.api.nvim_get_current_win()
    vim.cmd("vert diffsplit " .. tmp)
    vim.api.nvim_buf_set_name(0, "depot:" .. vim.fn.expand("%:t"))
    local depot_buf = vim.api.nvim_get_current_buf()
    local function close_diff()
        vim.cmd("diffoff!")
        vim.api.nvim_buf_delete(depot_buf, { force = true })
        if vim.api.nvim_win_is_valid(orig_win) then
            vim.api.nvim_set_current_win(orig_win)
        end
    end
    vim.keymap.set("n", "q", close_diff, { buffer = depot_buf, noremap = true, silent = true, desc = "p4 close diff" })
    vim.keymap.set("n", "<Esc>", close_diff, { buffer = depot_buf, noremap = true, silent = true })
end, { noremap = true, silent = true, desc = "p4 diff against depot" })

vim.keymap.set("n", "<leader>pe", function()
    local ok = p4_notify("edit", { vim.fn.expand("%:p") })
    if ok then
        vim.cmd("checktime")
        vim.api.nvim_feedkeys("L", "n", false)
    end
end, { noremap = true, silent = true, desc = "p4 edit" })

vim.keymap.set("n", "<leader>pa", function()
    p4_notify("add", { vim.fn.expand("%:p") })
end, { noremap = true, silent = true, desc = "p4 add" })

vim.keymap.set("n", "<leader>pr", function()
    local ok = p4_notify("revert", { vim.fn.expand("%:p") })
    if ok then
        vim.cmd("edit!")
    end
end, { noremap = true, silent = true, desc = "p4 revert" })

vim.keymap.set("n", "<leader>pv", function()
    local result = vim.fn.system({ "p4", "where", vim.fn.expand("%:p") })
    vim.notify(result, vim.log.levels.INFO)
end, { noremap = true, silent = true, desc = "p4 where" })

vim.keymap.set("n", "<leader>pl", function()
    local file = vim.fn.expand("%:p")
    local result = vim.fn.system({ "p4", "filelog", "-l", file })
    if vim.v.shell_error ~= 0 or vim.trim(result) == "" then
        vim.notify("p4: no filelog output", vim.log.levels.WARN)
        return
    end
    local lines, cls = {}, {}
    local current_cl, current_meta = nil, nil
    for line in result:gmatch("[^\n]+") do
        if line:match("^%... #%d+") then
            current_cl = line:match("change (%d+)")
            current_meta = line
        elseif line:match("^\t") and current_meta then
            table.insert(lines, current_meta .. "  |  " .. vim.trim(line))
            table.insert(cls, current_cl)
            current_cl, current_meta = nil, nil
        end
    end
    local buf = p4_scratch_buf(lines)
    p4_buf_close_keys(buf, "p4 close filelog")
    vim.keymap.set("n", "<CR>", function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local cl = cls[row]
        if not cl then
            return
        end
        local tmp_curr = vim.fn.tempname()
        local tmp_prev = vim.fn.tempname()
        vim.fn.system({ "p4", "print", "-q", "-o", tmp_curr, file .. "@" .. cl })
        if vim.v.shell_error ~= 0 then
            return
        end
        vim.fn.system({ "p4", "print", "-q", "-o", tmp_prev, file .. "@" .. (tonumber(cl) - 1) })
        if vim.v.shell_error ~= 0 then
            return
        end
        local log_row = row
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
        vim.cmd("topleft vert edit " .. vim.fn.fnameescape(tmp_curr))
        vim.api.nvim_buf_set_name(0, "cl:" .. cl .. " " .. vim.fn.fnamemodify(file, ":t"))
        local curr_buf = vim.api.nvim_get_current_buf()
        vim.cmd("diffthis")
        vim.cmd("vert diffsplit " .. vim.fn.fnameescape(tmp_prev))
        vim.api.nvim_buf_set_name(0, "cl:prev " .. vim.fn.fnamemodify(file, ":t"))
        local prev_buf = vim.api.nvim_get_current_buf()
        local function close_diff()
            vim.cmd("diffoff!")
            vim.api.nvim_buf_delete(curr_buf, { force = true })
            vim.api.nvim_buf_delete(prev_buf, { force = true })
            p4_reopen_buf(buf, lines, log_row)
        end
        for _, b in ipairs({ curr_buf, prev_buf }) do
            vim.keymap.set("n", "q", close_diff, { buffer = b, noremap = true, silent = true, desc = "p4 close diff" })
            vim.keymap.set("n", "<Esc>", close_diff, { buffer = b, noremap = true, silent = true })
        end
    end, { buffer = buf, noremap = true, silent = true, desc = "p4 diff CL" })
end, { noremap = true, silent = true, desc = "p4 filelog" })

vim.keymap.set("n", "<leader>po", function()
    local lines, depot_paths = p4_opened_lines()
    if not lines then
        vim.notify("p4: no files open", vim.log.levels.INFO)
        return
    end
    local buf = p4_scratch_buf(lines)
    p4_buf_close_keys(buf, "p4 close opened")
    -- vim.keymap.set("n", "<CR>", function()
    --     local row = vim.api.nvim_win_get_cursor(0)[1]
    --     local depot = depot_paths[row]
    --     if not depot or depot == "" then
    --         return
    --     end
    --     local log_row = row
    --     vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
    --     p4_open_diff_against_depot(depot, function()
    --         p4_reopen_buf(buf, lines, log_row)
    --     end)
    -- end, { buffer = buf, noremap = true, silent = true, desc = "p4 diff file" })
    vim.keymap.set("n", "<CR>", function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local depot = depot_paths[row]
        if not depot or depot == "" then
            return
        end
        local fpath = p4_resolve_local(depot)
        if fpath == "" then
            vim.notify("p4: could not resolve " .. depot, vim.log.levels.WARN)
            return
        end
        vim.cmd("bd!")
        vim.cmd("edit " .. vim.fn.fnameescape(fpath))
    end, { buffer = buf, noremap = true, silent = true, desc = "p4 open file" })
    vim.keymap.set("n", "r", function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local depot = depot_paths[row]
        if not depot or depot == "" then
            return
        end
        local ok = p4_notify("revert", { depot })
        if ok then
            vim.api.nvim_buf_set_option(buf, "modifiable", true)
            vim.api.nvim_buf_set_lines(buf, row - 1, row, false, {})
            table.remove(depot_paths, row)
            table.remove(lines, row)
            vim.api.nvim_buf_set_option(buf, "modifiable", false)
            if #depot_paths == 0 then
                vim.cmd("bd!")
            end
        end
    end, { buffer = buf, noremap = true, silent = true, desc = "p4 revert file" })
end, { noremap = true, silent = true, desc = "p4 opened files" })

vim.keymap.set("n", "<leader>ps", function()
    local lines, depot_paths = p4_opened_lines()
    if not lines then
        vim.notify("p4: no files open", vim.log.levels.INFO)
        return
    end
    local buf = p4_scratch_buf(lines)
    p4_buf_close_keys(buf, "p4 close submit list")
    vim.keymap.set("n", "<CR>", function()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local depot = depot_paths[row]
        if not depot or depot == "" then
            return
        end
        local log_row = row
        vim.api.nvim_buf_set_option(buf, "bufhidden", "hide")
        p4_open_diff_against_depot(depot, function()
            p4_reopen_buf(buf, lines, log_row)
        end)
    end, { buffer = buf, noremap = true, silent = true, desc = "p4 diff file" })
    vim.keymap.set("n", "s", function()
        vim.ui.input({ prompt = "Submit description: " }, function(desc)
            if not desc or vim.trim(desc) == "" then
                vim.notify("p4: submit cancelled", vim.log.levels.INFO)
                return
            end
            vim.cmd("bd!")
            vim.cmd("botright 15split")
            vim.cmd("terminal p4 submit -d " .. vim.fn.shellescape(desc))
            vim.cmd("normal G")
            local term_buf = vim.api.nvim_get_current_buf()
            p4_buf_close_keys(term_buf, "p4 close submit output")
        end)
    end, { buffer = buf, noremap = true, silent = true, desc = "p4 submit" })
end, { noremap = true, silent = true, desc = "p4 submit changelist" })

vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
        local file = vim.fn.expand("%:p")
        if file == "" then
            return
        end
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
            vim.cmd("checktime")
            vim.defer_fn(function()
                vim.api.nvim_feedkeys("L", "n", false)
            end, 50)
        end
    end,
})

local ns = vim.api.nvim_create_namespace("p4blame")
local enabled = false

local function clear()
    vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)
    enabled = false
end

local blame_buf = nil
local blame_win = nil

local function toggle()
    if enabled then
        if blame_win and vim.api.nvim_win_is_valid(blame_win) then
            vim.api.nvim_win_close(blame_win, true)
        end
        if blame_buf and vim.api.nvim_buf_is_valid(blame_buf) then
            vim.api.nvim_buf_delete(blame_buf, { force = true })
        end
        blame_buf = nil
        blame_win = nil
        enabled = false
        return
    end

    local file = vim.fn.expand("%:p")
    local lines = vim.fn.systemlist("p4 annotate -cu " .. vim.fn.shellescape(file))
    local blame_lines = {}

    for idx, line in ipairs(lines) do
        if idx > 1 then
            local cl, user = line:match("^(%s*%d+):%s+(%S+)")
            if cl then
                table.insert(blame_lines, string.format("%s  %s", vim.trim(cl), user))
            else
                table.insert(blame_lines, "")
            end
        end
    end

    -- create scratch buffer
    blame_buf = vim.api.nvim_create_buf(false, true)
    vim.api.nvim_buf_set_lines(blame_buf, 0, -1, false, blame_lines)
    vim.bo[blame_buf].modifiable = false
    vim.bo[blame_buf].buftype = "nofile"

    -- open left split
    local width = 30
    vim.cmd("topleft " .. width .. "vsplit")
    blame_win = vim.api.nvim_get_current_win()
    vim.api.nvim_win_set_buf(blame_win, blame_buf)
    vim.wo[blame_win].number = false
    vim.wo[blame_win].relativenumber = false
    vim.wo[blame_win].signcolumn = "no"
    vim.wo[blame_win].wrap = false

    -- sync scrolling
    vim.wo[blame_win].scrollbind = true
    vim.cmd("wincmd p") -- jump back to source window
    vim.wo.scrollbind = true

    enabled = true
end
-- local function toggle()
--     if enabled then
--         clear()
--         return
--     end
--
--     local file = vim.fn.expand("%:p")
--     local lines = vim.fn.systemlist("p4 annotate -cu " .. vim.fn.shellescape(file))
--
--     for i, line in ipairs(lines) do
--         local cl, user = line:match("^(%s*%d+):%s+(%S+)")
--         if cl then
--             cl = vim.trim(cl)
--             vim.api.nvim_buf_set_extmark(0, ns, i - 1, 0, {
--                 virt_text = {
--                     { string.format(" %s  %s", user, cl), "Comment" },
--                 },
--                 virt_text_pos = "overlay",
--                 virt_text_win_col = 160,
--             })
--         end
--     end
--
--     enabled = true
-- end

vim.api.nvim_create_user_command("P4BlameToggle", toggle, {})
vim.keymap.set("n", "<leader>pb", "<cmd>P4BlameToggle<CR>", { desc = "toggle p4 blame" })

-- require("which-key").add({ { "<leader>p", group = "perforce" } })

return {}
