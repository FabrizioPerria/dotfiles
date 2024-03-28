local function match_path()
    local projects = require("telescope._extensions.project.utils").get_projects("recent")
    for _, project in pairs(projects) do
        local s, _ = string.find(vim.fn.expand(vim.api.nvim_buf_get_name(0)), project.path)
        if s == 1 then
            vim.cmd(":cd " .. project.path)
            return project.path
        end
    end
    return require("telescope.utils").buffer_dir()
end

return {
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = false,
        keys = {
            { "<leader>fv", "<cmd>Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>", "Show file browser", silent = false, mode = { "n" } },
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
        "nvim-telescope/telescope-project.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        keys = {
            { "<leader>fp", "<cmd>Telescope project<CR>", "Show marked projects", silent = false, mode = { "n" } },
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
            { "<F3>", "<cmd>Telescope dap variables<CR>",        "List variables",   mode = { "n" } },
            { "<F4>", "<cmd>Telescope dap list_breakpoints<CR>", "List breakpoints", mode = { "n" } },
            { "<F6>", "<cmd>Telescope dap frames<CR>",           "List frames",      mode = { "n" } }
        }
    },
    {
        "nvim-telescope/telescope-undo.nvim",
        dependencies = { "nvim-telescope/telescope.nvim" },
        lazy = true,
        keys = {
            { "<leader>u", "<cmd>Telescope undo<CR>", "Undo menu", mode = { "n", "x" } },
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
            { "<leader>/",  false },
            { "<leader>ff", function() require("telescope.builtin").find_files({ cwd = match_path() }) end,                                                             "Fuzzy file search",                   mode = { "n" } },
            { "<leader>fb", "<cmd> Telescope buffers<CR>",                                                                                                              "Show buffers",                        silent = false,     mode = { "n" } },
            { "<leader>fg", "<cmd> Telescope git_files<CR>",                                                                                                            "Fuzzy file search in git repository", mode = { "n" } },
            { "<leader>fr", "<cmd> Telescope registers<CR>",                                                                                                            "Peek Register contents",              mode = { "n", "v" } },
            { "<leader>fs", function() require("telescope.builtin").live_grep({ search_dir = "%:p:h" }) end,                                                            "Grep search",                         mode = { "n" } },
            { "<leader>fk", "<cmd>Telescope keymaps<CR>",                                                                                                               "Show keymaps",                        mode = { "n" } },
            { "<leader>fh", "<cmd>Telescope help_tags<CR>",                                                                                                             "Find man pages for vim commands",     mode = { "n" } },
            { "<leader>gB", "<cmd>Telescope git_branches<CR>",                                                                                                          " ",                                   silent = false,     mode = { "n" } },
            { "<leader>gs", "<cmd>Telescope git_stash<CR>",                                                                                                             " ",                                   silent = false,     mode = { "n" } },
            { "<leader>gf", "<cmd>Telescope git_files<CR>",                                                                                                             " ",                                   silent = false,     mode = { "n" } },
            { "<leader>gl", "<cmd>Telescope git_commits<CR>",                                                                                                           " ",                                   silent = false,     mode = { "n" } },
            { "<leader>cd", function() match_path() end,                                                                                                                "",                                    mode = { "n" } },
            { "<leader>tt", "<cmd>TodoTelescope<CR>",                                                                                                                   "Show todo list",                      mode = { "n" } },
            { "<leader>vS", function() require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbol_width = 60, symbol_type_width = 30, fname_width = 50 }) end, "Show current Workspace Symbols",      mode = { "n" } },
            { "<leader>vs", function() require("telescope.builtin").lsp_document_symbols({ symbol_width = 60, symbol_type_width = 30, fname_width = 80 }) end,          "Show symbols in document",            mode = { "n" } },
            { "<leader>vr", function() require("telescope.builtin").lsp_references({ fname_width = 80 }) end,                                                           "Show references",                     mode = { "n" } },
            { "<leader>vd", function() require("telescope.builtin").lsp_definitions({ jump_type = "vsplit", fname_width = 80 }) end,                                    "Go to definition",                    mode = { "n" } },
            { "<leader>vt", function() require("telescope.builtin").lsp_type_definitions({ fname_width = 80 }) end,                                                     "Go to type definition",               mode = { "n" } },
            { "<leader>vi", function() require("telescope.builtin").lsp_implementations({ fname_width = 80 }) end,                                                      "Go to implementation",                mode = { "n" } },
            { "<leader>ve", function() require("telescope.builtin").diagnostics() end,                                                                                  "Show diagnostics",                    mode = { "n" } }
        },
        config = function()
            require("telescope").setup({
                extensions = {
                    -- { "<leader>vui-select", require("telescope.themes").get_dropdown({}) },
                    file_browser = {
                        hidden = true,
                        hijack_netrw = true,
                        no_ignore = true
                    },
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case"
                    }
                },
                defaults = {
                    path_display = { "truncate" },
                    mappings = {
                        i = {
                            ["<C-k>"] = require('telescope.actions').preview_scrolling_up,
                            ["<C-j>"] = require('telescope.actions').preview_scrolling_down,
                            ["<C-h>"] = require('telescope.actions').preview_scrolling_left,
                            ["<C-l>"] = require('telescope.actions').preview_scrolling_right
                        },
                        n = {
                            ["<C-k>"] = require('telescope.actions').preview_scrolling_up,
                            ["<C-j>"] = require('telescope.actions').preview_scrolling_down,
                            ["<C-h>"] = require('telescope.actions').preview_scrolling_left,
                            ["<C-l>"] = require('telescope.actions').preview_scrolling_right
                        }
                    },
                    vimgrep_arguments = { "rg", "--color=never", "--no-heading", "--with-filename", "--line-number",
                        "--column", "--smart-case", "--hidden" },
                    preview = {
                        treesitter = true
                    }
                },
                pickers = {
                    buffers = {
                        mappings = {
                            n = {
                                ["d"] = require('telescope.actions').delete_buffer
                            },
                            i = {
                                ["<A-d>"] = require('telescope.actions').delete_buffer
                            }
                        }
                    },
                    git_status = {
                        mappings = {
                            n = {
                                ["d"] = function(prompt_bufnr)
                                    local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                                    os.execute("git checkout -- " .. selection.value)
                                    actions._close(prompt_bufnr, true)
                                    require("telescope.builtin").git_status()
                                end
                            },
                            i = {
                                ["<A-d>"] = function(prompt_bufnr)
                                    local selection = require('telescope.actions.state').get_selected_entry(prompt_bufnr)
                                    os.execute("git checkout -- " .. selection.value)
                                    actions._close(prompt_bufnr, true)
                                    require("telescope.builtin").git_status()
                                end
                            }
                        }
                    },
                    find_files = {
                        find_command = { "fd", ".", "--type", "f", "--hidden", -- '--no-ignore',
                            "--strip-cwd-prefix", "--exclude", "node_modules", "--exclude", "Library", "--exclude",
                            ".DS_Store",
                            "--exclude", ".Trash", "--exclude", ".cache", "--exclude", ".git", "--exclude",
                            ".local", "--exclude", ".nuget" }
                    }
                }
            })
        end
    }
}
