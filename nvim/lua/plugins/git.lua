local blameFormat = function(line_porcelain, config, idx)
    local hash = string.sub(line_porcelain.hash, 0, 7)
    local line_with_hl = {}
    local is_commited = hash ~= "0000000"
    if is_commited then
        local summary
        if #line_porcelain.summary > config.max_summary_width then
            summary = string.sub(line_porcelain.summary, 0, config.max_summary_width - 3) .. "..."
        else
            summary = line_porcelain.summary
        end
        summary = string.gsub(summary, "Merged in ", "⇵")
        line_with_hl = {
            idx = idx,
            values = {
                {
                    textValue = summary,
                    hl = "Comment",
                },
                {
                    textValue = os.date(config.date_format, line_porcelain.committer_time),
                    hl = "Comment",
                },
                {
                    textValue = line_porcelain.author,
                    hl = hash,
                },
                {
                    textValue = hash,
                    hl = "Comment",
                },
            },
            format = "%s (%s) %s\t%s",
        }
    else
        line_with_hl = {
            idx = idx,
            values = {
                {
                    textValue = "Not committed",
                    hl = "Comment",
                },
            },
            format = "%s",
        }
    end
    return line_with_hl
end

return {
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require("gitsigns").setup({
                signs = {
                    add = { text = "+" },
                    change = { text = "~" },
                    delete = { text = "_" },
                    topdelete = { text = "‾" },
                    changedelete = { text = "-" },
                    untracked = { text = "►" },
                },
            })
        end,
    },
    {
        "FabijanZulj/blame.nvim",
        lazy = false,
        config = function()
            require("blame").setup({
                date_format = "%d.%m.%Y",
                virtual_style = "float",
                focus_blame = true,
                merge_consecutive = false,
                max_summary_width = 40,
                colors = nil,
                blame_options = nil,
                commit_detail_view = "vsplit",
                format_fn = blameFormat,
                mappings = {
                    commit_info = "i",
                    stack_push = "<TAB>",
                    stack_pop = "<BS>",
                    show_commit = "<CR>",
                    close = { "<esc>", "q" },
                },
            })
        end,
        opts = {
            blame_options = { "-w" },
        },
        keys = {
            { "<leader>gb", "<cmd>BlameToggle virtual<CR>", desc = "toggle git blame - virtual" },
            { "<leader>gB", "<cmd>BlameToggle window<CR>", desc = "toggle git blame - window" },
        },
    },
}
