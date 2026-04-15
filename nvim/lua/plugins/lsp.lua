return {
    { "mfussenegger/nvim-jdtls" },
    { "seblyng/roslyn.nvim" },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
    },
    {
        "llllvvuu/nvim-cmp",
        branch = "feat/above",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
            "zbirenbaum/copilot.lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",

            { "FelipeLema/cmp-async-path", lazy = true },
            { "dmitmel/cmp-cmdline-history", lazy = true },
            { "rcarriga/cmp-dap", lazy = true },
            { "hrsh7th/cmp-nvim-lsp-signature-help", lazy = true },
            { "hrsh7th/cmp-calc", lazy = true },
            { "ray-x/cmp-treesitter", lazy = true },
            {
                "lukas-reineke/cmp-rg",
                lazy = true,
                enabled = function()
                    return vim.fn.executable("rg") == 1
                end,
            },
            { "abecodes/tabout.nvim", opts = { ignore_beginning = false, completion = false }, lazy = true },
        },
        lazy = true,
        event = { "InsertEnter", "CmdlineEnter" },

        opts = function()
            local cmp = require("cmp")
            require("cmp").setup({
                preselect = "none",
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "symbol_text", -- show only symbol annotations
                        maxwidth = 80, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    }),
                },
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "top_down",
                        vertical_positioning = "above",
                    },
                    docs = {
                        auto_open = true,
                    },
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    {
                        name = "nvim_lua",
                        entry_filter = function()
                            if vim.bo.filetype ~= "lua" then
                                return false
                            end
                            return true
                        end,
                        priority = 150,
                        group_index = 1,
                    },
                    {
                        name = "nvim_lsp",
                        priority = 100,
                        group_index = 1,
                    },
                    { name = "nvim_lsp_signature_help", priority = 100, group_index = 1 },
                    {
                        name = "treesitter",
                        max_item_count = 5,
                        priority = 90,
                        group_index = 5,
                        entry_filter = function(entry, vim_item)
                            if entry.kind == 15 then
                                local cursor_pos = vim.api.nvim_win_get_cursor(0)
                                local line = vim.api.nvim_get_current_line()
                                local next_char = line:sub(cursor_pos[2] + 1, cursor_pos[2] + 1)
                                if next_char == '"' or next_char == "'" then
                                    vim_item.abbr = vim_item.abbr:sub(1, -2)
                                end
                            end
                            return vim_item
                        end,
                    },
                    {
                        name = "rg",
                        keyword_length = 5,
                        max_item_count = 5,
                        option = {
                            additional_arguments = "--smart-case --hidden",
                        },
                        priority = 80,
                        group_index = 3,
                    },
                    {
                        name = "buffer",
                        max_item_count = 5,
                        keyword_length = 2,
                        priority = 50,
                        entry_filter = function(entry)
                            return not entry.exact
                        end,
                        option = {
                            get_bufnrs = function()
                                return vim.api.nvim_list_bufs()
                            end,
                        },
                        group_index = 4,
                    },
                    { name = "dap", priority = 40, group_index = 6 },
                    { name = "async_path", priority = 30, group_index = 5 },
                }),

                mapping = cmp.mapping.preset.insert({
                    ["<Up>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    ["<Down>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    ["<Enter>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    }),
                    ["<C-j>"] = cmp.mapping.scroll_docs(4),
                    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
            })
        end,
    },
}
