local lsp_work_by_client_id = {}
vim.api.nvim_create_autocmd("LspProgress", {
    desc = "Update the Lualine LSP status component with progress",
    group = vim.api.nvim_create_augroup("lualine_lsp_progress", {}),
    callback = function(event)
        local client_id = event.data.client_id
        local params = event.data and event.data.params or {}
        local value = params.value

        local work = lsp_work_by_client_id[client_id] or 0
        local work_change = 0

        if type(value) == "table" and value.kind == "begin" then
            work_change = 1
        elseif type(value) == "table" and value.kind == "end" then
            work_change = -1
        end

        lsp_work_by_client_id[client_id] = math.max(work + work_change, 0)
        require("lualine").refresh()
    end,
})

function lsp_clients(args)
    local buf_clients = vim.lsp.get_clients({ bufnr = 0 })
    if #buf_clients == 0 then
        return ""
    end

    local names = {}
    for _, client in pairs(buf_clients) do
        if not args.ignore or not vim.tbl_contains(args.ignore, client.name) then
            local busy = lsp_work_by_client_id[client.id] and lsp_work_by_client_id[client.id] > 0
            table.insert(names, client.name .. " " .. (busy and "" or ""))
        end
    end

    return table.concat(names, args.separator or ",")
end

function GetCurrentWorkingDirectory()
    return vim.fn.getcwd()
end

return {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = "VeryLazy",
    opts = {
        sections = {
            lualine_c = {
                { "GetCurrentWorkingDirectory()", icons_enabled = true, icon = "" },
                { "filename", path = 1, icons_enabled = true, icon = "" },
            },
            lualine_x = { "encoding", "fileformat", "filetype" },
            lualine_y = { "progress", "location" },
            lualine_z = {
                {
                    "lsp_clients({ separator = '  ', ignore = { 'null-ls' } })",
                },
            },
        },
    },
}
