local function match_path()
    local clients = vim.lsp.get_active_clients()
    for _, client in ipairs(clients) do
        if client.config.root_dir then
            return client.config.root_dir
        end
    end
    local projects = require("telescope._extensions.project.utils").get_projects("recent")
    for _, project in pairs(projects) do
        local s, _ = string.find(vim.fn.expand(vim.api.nvim_buf_get_name(0)), project.path)
        if s == 1 then
            vim.cmd(":cd " .. project.path)
            return project.path
        end
    end
    return vim.fn.getcwd()
end

return {
    {
        "nvim-lua/plenary.nvim",
        lazy = false,
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = false,
        keys = {
            {
                "<leader>fv",
                "<cmd>Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>",
                desc = "Show file browser",
                silent = false,
                mode = { "n" },
            },
        },
        config = function()
            require("telescope").load_extension("file_browser")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        build = "make",
        lazy = true,
        config = function()
            require("telescope").load_extension("fzf")
        end,
    },
    {
        "nvim-telescope/telescope-live-grep-args.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        config = function()
            require("telescope").load_extension("live_grep_args")
        end,
        keys = {
            {
                "<leader>fs",
                function()
                    require("custom.livegrep").livegrep()
                end,
                desc = "Grep search with arguments",
                mode = { "n" },
            },
        },
    },
    {
        "nvim-telescope/telescope-project.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        keys = {
            {
                "<leader>fp",
                "<cmd>Telescope project<CR>",
                desc = "Show marked projects",
                silent = false,
                mode = { "n" },
            },
        },
        config = function()
            require("telescope").load_extension("project")
        end,
    },
    {
        "nvim-telescope/telescope-dap.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        config = function()
            require("telescope").load_extension("dap")
        end,
        keys = {
            { "<F3>", "<cmd>Telescope dap variables<CR>", desc = "List variables", mode = { "n" } },
            { "<F4>", "<cmd>Telescope dap list_breakpoints<CR>", desc = "List breakpoints", mode = { "n" } },
            { "<F6>", "<cmd>Telescope dap frames<CR>", desc = "List frames", mode = { "n" } },
        },
    },
    {
        "debugloop/telescope-undo.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        keys = {
            { "<leader>u", "<cmd>Telescope undo<CR>", desc = "Undo menu", mode = { "n", "x" } },
        },
        config = function()
            require("telescope").load_extension("undo")
        end,
    },
    {
        "nvim-telescope/telescope-ui-select.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        config = function()
            require("telescope").load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        lazy = false,
        keys = {
            -- { "<leader>/",  false },
            {
                "<leader>.",
                "<cmd>Telescope current_buffer_fuzzy_find<CR>",
                desc = "Fuzzy search in current buffer",
                mode = { "n" },
            },

            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files({ cwd = match_path() })
                end,
                desc = "Fuzzy file search",
                mode = { "n" },
            },
            {
                "<leader>fb",
                "<cmd> Telescope buffers<CR>",
                desc = "Show buffers",
                silent = false,
                mode = { "n" },
            },
            {
                "<leader>fg",
                "<cmd> Telescope git_files<CR>",
                desc = "Fuzzy file search in git repository",
                mode = { "n" },
            },
            {
                "<leader>fd",
                function()
                    opts = {
                        -- severity = vim.diagnostic.severity.ERROR,
                        line_width = "full",
                        wrap_results = true,
                        highlight_entry = true,
                        show_code = true,
                    }
                    require("custom.diagnostics").diagnostics(opts)
                end,
                desc = "List diagnostics",
                mode = { "n", "v" },
            },
            {
                "<leader>fR",
                "<cmd> Telescope registers<CR>",
                desc = "Peek Register contents",
                mode = { "n", "v" },
            },
            {
                "<leader>fr",
                "<cmd> Telescope oldfiles<CR>",
                desc = "Show recently opened files",
                mode = { "n", "v" },
            },
            {
                "<leader>fk",
                "<cmd>Telescope keymaps<CR>",
                desc = "Show keymaps",
                mode = { "n" },
            },
            {
                "<leader>fh",
                "<cmd>Telescope help_tags<CR>",
                desc = "Find man pages for vim commands",
                mode = { "n" },
            },
            {
                "<leader>gB",
                "<cmd>Telescope git_branches<CR>",
                desc = "Show git branches",
                silent = false,
                mode = { "n" },
            },
            {
                "<leader>gs",
                "<cmd>Telescope git_stash<CR>",
                desc = "show git stash",
                silent = false,
                mode = { "n" },
            },
            {
                "<leader>gl",
                "<cmd>Telescope git_commits<CR>",
                desc = "Show git log",
                silent = false,
                mode = { "n" },
            },
            {
                "<leader>cd",
                function()
                    match_path()
                end,
                desc = "Set current directory as working directory",
                mode = { "n" },
            },
            {
                "<leader>bS",
                function()
                    require("telescope.builtin").lsp_dynamic_workspace_symbols({
                        symbol_width = 60,
                        symbol_type_width = 30,
                        fname_width = 50,
                    })
                end,
                desc = "Show current Workspace Symbols",
                mode = { "n" },
            },
            {
                "<leader>bs",
                function()
                    require("telescope.builtin").lsp_document_symbols({
                        symbol_width = 60,
                        symbol_type_width = 30,
                        fname_width = 80,
                    })
                end,
                desc = "Show symbols in document",
                mode = { "n" },
            },
            {
                "<leader>br",
                function()
                    require("telescope.builtin").lsp_references({ fname_width = 80 })
                end,
                desc = "Show references",
                mode = { "n" },
            },
            {
                "<leader>bd",
                function()
                    require("telescope.builtin").lsp_definitions({ jump_type = "vsplit", fname_width = 80 })
                end,
                desc = "Go to definition",
                mode = { "n" },
            },
            {
                "<leader>bt",
                function()
                    require("telescope.builtin").lsp_type_definitions({ fname_width = 80 })
                end,
                desc = "Go to type definition",
                mode = { "n" },
            },
            {
                "<leader>bi",
                function()
                    require("telescope.builtin").lsp_implementations({ fname_width = 80 })
                end,
                desc = "Go to implementation",
                mode = { "n" },
            },
            {
                "<leader>be",
                function()
                    require("telescope.builtin").diagnostics()
                end,
                desc = "Show diagnostics",
                mode = { "n" },
            },
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    -- { "<leader>vui-select", require("telescope.themes").get_dropdown({}) },
                    file_browser = {
                        hidden = true,
                        hijack_netrw = true,
                        no_ignore = true,
                    },
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
                defaults = {
                    layout_strategy = "horizontal",
                    layout_config = {
                        horizontal = {
                            prompt_position = "top",
                            width = { padding = 0 },
                            height = { padding = 0 },
                            preview_width = 0.5,
                        },
                    },
                    sorting_strategy = "ascending",

                    preview_title = false,
                    dynamic_preview_title = true,
                    title_dynamic = function(_, filepath)
                        return vim.fn.fnamemodify(filepath, ":t")
                    end,

                    path_display = { "smart" },
                    mappings = {
                        i = {
                            ["<C-k>"] = require("telescope.actions").preview_scrolling_up,
                            ["<C-j>"] = require("telescope.actions").preview_scrolling_down,
                            ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
                            ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
                        },
                        n = {
                            ["<C-k>"] = require("telescope.actions").preview_scrolling_up,
                            ["<C-j>"] = require("telescope.actions").preview_scrolling_down,
                            ["<C-h>"] = require("telescope.actions").preview_scrolling_left,
                            ["<C-l>"] = require("telescope.actions").preview_scrolling_right,
                        },
                    },
                    vimgrep_arguments = {
                        "rg",
                        "--color=never",
                        "--no-heading",
                        "--with-filename",
                        "--line-number",
                        "--column",
                        "--smart-case",
                        "--hidden",
                        "--glob=!.git/",
                    },
                    preview = {
                        treesitter = true,
                    },
                },
                pickers = {
                    diagnostics = {
                        line_width = "full",
                        wrap_results = true,
                        path_display = { "hidden" },
                    },
                    buffers = {
                        mappings = {
                            n = {
                                ["d"] = require("telescope.actions").delete_buffer,
                            },
                            i = {
                                ["<A-d>"] = require("telescope.actions").delete_buffer,
                            },
                        },
                    },
                    git_status = {
                        mappings = {
                            n = {
                                ["d"] = function(prompt_bufnr)
                                    local selection =
                                        require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                                    os.execute("git checkout -- " .. selection.value)
                                    require("telescope.actions")._close(prompt_bufnr, true)
                                    require("telescope.builtin").git_status()
                                end,
                            },
                            i = {
                                ["<A-d>"] = function(prompt_bufnr)
                                    local selection =
                                        require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                                    os.execute("git checkout -- " .. selection.value)
                                    require("telescope.actions")._close(prompt_bufnr, true)
                                    require("telescope.builtin").git_status()
                                end,
                            },
                        },
                    },
                    find_files = {
                        find_command = {
                            "fd",
                            ".",
                            "--type",
                            "f",
                            "--hidden", -- '--no-ignore',
                            "--strip-cwd-prefix",
                            "--exclude",
                            "node_modules",
                            "--exclude",
                            "Library",
                            "--exclude",
                            ".DS_Store",
                            "--exclude",
                            ".Trash",
                            "--exclude",
                            ".cache",
                            "--exclude",
                            ".git",
                            "--exclude",
                            ".local",
                            "--exclude",
                            ".nuget",
                        },
                    },
                },
            })
        end,
    },
    {
        "aznhe21/actions-preview.nvim",
        event = "VeryLazy",
        keys = {
            {
                "<leader>fa",
                function()
                    require("actions-preview").code_actions()
                end,
                desc = "Show code actions",
                mode = { "n", "v" },
            },
        },
        config = function()
            require("actions-preview").setup({
                use_diagnostic_signs = true,
                show_server_name = true,
                show_icon = true,
                border = "rounded",
                max_height = 20,
                min_width = 50,
            })
        end,
    },
}
