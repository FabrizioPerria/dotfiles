local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local sorters = require("telescope.sorters")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")

local M = {}

local function get_severity_highlight(severity)
    local severity_map = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticError",
        [vim.diagnostic.severity.WARN] = "DiagnosticWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticHint",
    }
    return severity_map[severity] or "Normal"
end

function M.diagnostics(opts)
    opts = opts or {}

    -- if severity is not provided, default to showing all diagnostics
    if not opts.severity then
        opts.severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
        }
    end

    local diagnostics_by_file = {}
    for _, diag in ipairs(vim.diagnostic.get(nil, { severity = opts.severity })) do
        local filename = vim.api.nvim_buf_get_name(diag.bufnr)
        diagnostics_by_file[filename] = diagnostics_by_file[filename] or {}
        table.insert(diagnostics_by_file[filename], diag)
    end

    local diagnostics = {}
    for filename, diags in pairs(diagnostics_by_file) do
        for _, diag in ipairs(diags) do
            table.insert(diagnostics, diag)
        end
    end

    local displayer = entry_display.create({
        separator = "   ",
        items = {
            { width = 2 }, -- severity sign
            -- { width = 6 }, -- line
            -- { width = 4 }, -- column
            { width = 15 }, -- filename
            { remaining = true }, -- message
            { remaining = true }, -- code
        },
    })

    local make_display = function(entry)
        return displayer({
            { entry.severity_sign, entry.severity_highlight },
            -- { tostring(entry.lnum) },
            -- { tostring(entry.col) },
            { vim.fn.fnamemodify(entry.filename, ":t"), "Comment" },
            { entry.text, opts.highlight_entry and entry.severity_highlight or "Normal" },
            { opts.show_code and tostring(entry.code) or "", "Comment" },
        })
    end

    local function preprocess_diag(diagnostic)
        local bufnr = diagnostic.bufnr
        local lnum = diagnostic.lnum + 1
        local col = diagnostic.col + 1
        local text = diagnostic.message or ""
        local severity = diagnostic.severity
        local filename = vim.api.nvim_buf_get_name(bufnr)

        local signs = vim.diagnostic.config().signs.text
            or {
                [vim.diagnostic.severity.ERROR] = " ",
                [vim.diagnostic.severity.WARN] = " ",
                [vim.diagnostic.severity.HINT] = " ",
                [vim.diagnostic.severity.INFO] = " ",
            }

        return {
            value = diagnostic,
            ordinal = text,
            display = make_display,
            filename = filename,
            lnum = lnum,
            col = col,
            text = text,
            bufnr = bufnr,
            severity = severity,
            severity_sign = signs[severity] or "?",
            severity_highlight = get_severity_highlight(severity),
            code = diagnostic.code,
        }
    end

    local entries = vim.tbl_map(preprocess_diag, diagnostics)
    table.sort(entries, function(a, b)
        if a.filename == b.filename then
            return a.lnum < b.lnum
        else
            return a.filename < b.filename
        end
    end)

    pickers
        .new(opts, {
            prompt_title = "Diagnostics",
            finder = finders.new_table({
                results = entries,
                entry_maker = function(entry)
                    return entry
                end,
            }),
            previewer = conf.qflist_previewer(opts),
            sorter = sorters.get_generic_fuzzy_sorter(),
            layout_config = {
                horizontal = {
                    preview_width = 0.4,
                },
                vertical = {
                    preview_height = 0.4,
                },
            },
            -- layout_strategy = "horizontal",
            layout_strategy = "vertical",
        })
        :find()
end

return M
