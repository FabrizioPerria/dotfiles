return {
    "nvim-telescope/telescope.nvim",
    -- tag = "0.1.5",
    vscode = false,
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope-file-browser.nvim",
        "nvim-telescope/telescope-ui-select.nvim",
        "nvim-telescope/telescope-project.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "debugloop/telescope-undo.nvim",
        "nvim-telescope/telescope-packer.nvim",
        "nvim-telescope/telescope-dap.nvim",
        "folke/todo-comments.nvim",
    },
    keys = {
        { "<leader>/", vim.NIL },
        {
            "<leader>ff",
            "<cmd>Telescope find_files<cr>",
            desc = "Fuzzy file search",
            mode = { "n" },
        },
        { "<leader>g", "<cmd>Telescope git_status<cr>", desc = " Git status", mode = { "n" } },
        {
            "<leader>fb",
            "<cmd>Telescope buffers<cr>",
            desc = "Show buffers",
            mode = { "n" },
        },
        {
            "<leader>fg",
            "<cmd>Telescope git_files<cr>",
            desc = "Fuzzy file search in git repository",
            mode = { "n" },
        },
        {
            "<leader>fr",
            "<cmd>Telescope registers<cr>",
            "Peek Register contents",
            mode = { "n", "v" },
        },
        {
            "<leader>fs",
            "<cmd>lua require('telescope.builtin').live_grep({ search_dir = '%:p:h' })<cr>",
            desc = "Grep search",
            mode = { "n" },
        },
        {
            "<leader>fv",
            "<cmd>Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<cr>",
            desc = "Show file browser",
            mode = { "n" },
        },
        {
            "<leader>fk",
            "<cmd>Telescope keymaps<cr>",
            desc = "Show keymaps",
            mode = { "n" },
        },
        {
            "<leader>fh",
            "<cmd>Telescope help_tags<cr>",
            desc = "Find man pages for vim commands",
            mode = { "n" },
        },
        {
            "<leader>fp",
            "<cmd>Telescope project<cr>",
            desc = "Show marked projects",
            mode = { "n" },
        },
        { "<leader>ft", "<cmd>TodoTelescope<cr>",  mode = { "n" },     desc = "Show TODOs" },
        { "<leader>u",  "<cmd>Telescope undo<cr>", desc = "Undo menu", mode = { "n", "x" } },
        {
            "<leader>w",
            function()
                local projects = require("telescope._extensions.project.utils").get_projects("recent")
                for _, project in pairs(projects) do
                    local s, _ = string.find(vim.fn.expand(vim.api.nvim_buf_get_name(0)), project.path)
                    if s == 1 then
                        vim.cmd(":cd " .. project.path)
                        break
                    end
                end
            end,
            desc = "Change current Directory",
            mode = { "n" },
        },
        {
            "<leader>vS",
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
            "<leader>vs",
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
            "<leader>vr",
            function()
                require("telescope.builtin").lsp_references({ fname_width = 80 })
            end,
            desc = "Show references",
            mode = { "n" },
        },
        {
            "<leader>vd",
            function()
                require("telescope.builtin").lsp_definitions({ jump_type = "vsplit", fname_width = 80 })
            end,
            desc = "Go to definition",
            mode = { "n" },
        },
        {
            "<leader>vt",
            function()
                require("telescope.builtin").lsp_type_definitions({ fname_width = 80 })
            end,
            desc = "Go to type definition",
            mode = { "n" },
        },
        {
            "<leader>vi",
            function()
                require("telescope.builtin").lsp_implementations({ fname_width = 80 })
            end,
            desc = "Go to implementation",
            mode = { "n" },
        },
        {
            "<leader>ve",
            "<cmd>Telescope diagnostics<cr>",
            desc = "Show diagnostics",
            mode = { "n" },
        },
        { "<leader>gB", "<cmd>Telescope git_branches<cr>", " ", silent = false, mode = { "n" } },
        { "<leader>gs", "<cmd>Telescope git_stash<cr>",    " ", silent = false, mode = { "n" } },
        { "<leader>gf", "<cmd>Telescope git_files<cr>",    " ", silent = false, mode = { "n" } },
        { "<leader>gl", "<cmd>Telescope git_commits<cr>",  " ", silent = false, mode = { "n" } },
    },
    opts = {
        extensions = {
            ["ui-select"] = {
                require("telescope.themes").get_dropdown({}),
            },
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
            path_display = { "truncate" },
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
            },
            preview = { treesitter = true },
        },
        pickers = {
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
                            local selection = require("telescope.actions.state").get_selected_entry()
                            os.execute("git checkout -- " .. selection.value)
                            require("telescope.actions").close(prompt_bufnr)
                            require("telescope.builtin").git_status()
                        end,
                    },
                    i = {
                        ["<A-d>"] = function(prompt_bufnr)
                            local selection = require("telescope.actions.state").get_selected_entry()
                            os.execute("git checkout -- " .. selection.value)
                            require("telescope.actions").close(prompt_bufnr)
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
                    "--hidden",
                    -- '--no-ignore',
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
    },
    config = function(_, opts)
        local telescope = require("telescope")
        telescope.setup(opts)
        telescope.load_extension("file_browser")
        telescope.load_extension("fzf")
        telescope.load_extension("refactoring")
        telescope.load_extension("ui-select")
        telescope.load_extension("undo")
        telescope.load_extension("dap")
    end,
}
