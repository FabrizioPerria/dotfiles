local function match_path()
    local clients = vim.lsp.get_clients()
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

require("telescope").setup({
    extensions = {
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
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden", "--glob=!.git/",
        },
        preview = { treesitter = true },
    },
    pickers = {
        diagnostics = {
            line_width = "full",
            wrap_results = true,
            path_display = { "hidden" },
        },
        buffers = {
            mappings = {
                n = { ["d"] = require("telescope.actions").delete_buffer },
                i = { ["<A-d>"] = require("telescope.actions").delete_buffer },
            },
        },
        git_status = {
            mappings = {
                n = {
                    ["d"] = function(prompt_bufnr)
                        local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                        os.execute("git checkout -- " .. selection.value)
                        require("telescope.actions")._close(prompt_bufnr, true)
                        require("telescope.builtin").git_status()
                    end,
                },
                i = {
                    ["<A-d>"] = function(prompt_bufnr)
                        local selection = require("telescope.actions.state").get_selected_entry(prompt_bufnr)
                        os.execute("git checkout -- " .. selection.value)
                        require("telescope.actions")._close(prompt_bufnr, true)
                        require("telescope.builtin").git_status()
                    end,
                },
            },
        },
        find_files = {
            find_command = {
                "fd", ".", "--type", "f", "--hidden", "--strip-cwd-prefix",
                "--exclude", "node_modules", "--exclude", "Library",
                "--exclude", ".DS_Store", "--exclude", ".Trash",
                "--exclude", ".cache", "--exclude", ".git",
                "--exclude", ".local", "--exclude", ".nuget",
            },
        },
    },
})

require("telescope").load_extension("file_browser")
-- If fzf native isn't built yet, run: :BuildFzf
vim.api.nvim_create_user_command("BuildFzf", function()
    local plugin_path = vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim"
    vim.fn.system("make -C " .. plugin_path)
    require("telescope").load_extension("fzf")
    vim.notify("fzf native built and loaded", vim.log.levels.INFO)
end, {})

pcall(require("telescope").load_extension, "fzf")
require("telescope").load_extension("live_grep_args")
require("telescope").load_extension("project")
require("telescope").load_extension("dap")
require("telescope").load_extension("undo")
require("telescope").load_extension("ui-select")

require("actions-preview").setup({
    use_diagnostic_signs = true,
    show_server_name = true,
    show_icon = true,
    border = "rounded",
    max_height = 20,
    min_width = 50,
})

-- Keymaps
vim.keymap.set("n", "<leader>.", "<cmd>Telescope current_buffer_fuzzy_find<CR>", { desc = "Fuzzy search in current buffer" })
vim.keymap.set("n", "<leader>ff", function()
    require("telescope.builtin").find_files({ cwd = match_path() })
end, { desc = "Fuzzy file search" })
vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<CR>", { desc = "Show buffers" })
vim.keymap.set("n", "<leader>fg", "<cmd>Telescope git_files<CR>", { desc = "Fuzzy file search in git repository" })
vim.keymap.set("n", "<leader>fd", function()
    require("custom.diagnostics").diagnostics({
        line_width = "full",
        wrap_results = true,
        highlight_entry = true,
        show_code = true,
    })
end, { desc = "List diagnostics" })
vim.keymap.set("n", "<leader>fR", "<cmd>Telescope registers<CR>", { desc = "Peek Register contents" })
vim.keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<CR>", { desc = "Show recently opened files" })
vim.keymap.set("n", "<leader>fk", "<cmd>Telescope keymaps<CR>", { desc = "Show keymaps" })
vim.keymap.set("n", "<leader>fh", "<cmd>Telescope help_tags<CR>", { desc = "Find man pages for vim commands" })
vim.keymap.set("n", "<leader>fv", "<cmd>Telescope file_browser hidden=true noignore=true path=%:p:h select_buffer=true<CR>", { desc = "Show file browser" })
vim.keymap.set("n", "<leader>fp", "<cmd>Telescope project<CR>", { desc = "Show marked projects" })
vim.keymap.set("n", "<leader>fs", function()
    require("custom.livegrep").livegrep()
end, { desc = "Grep search with arguments" })
vim.keymap.set("n", "<leader>u", "<cmd>Telescope undo<CR>", { desc = "Undo menu" })
vim.keymap.set("n", "<leader>fa", function()
    require("actions-preview").code_actions()
end, { desc = "Show code actions" })
vim.keymap.set("n", "<F3>", "<cmd>Telescope dap variables<CR>", { desc = "List variables" })
vim.keymap.set("n", "<F4>", "<cmd>Telescope dap list_breakpoints<CR>", { desc = "List breakpoints" })
vim.keymap.set("n", "<F6>", "<cmd>Telescope dap frames<CR>", { desc = "List frames" })
vim.keymap.set("n", "<leader>gs", "<cmd>Telescope git_stash<CR>", { desc = "Show git stash" })
vim.keymap.set("n", "<leader>gl", "<cmd>Telescope git_commits<CR>", { desc = "Show git log" })
vim.keymap.set("n", "<leader>cd", function() match_path() end, { desc = "Set current directory as working directory" })
vim.keymap.set("n", "<leader>bS", function()
    require("telescope.builtin").lsp_dynamic_workspace_symbols({ symbol_width = 60, symbol_type_width = 30, fname_width = 50 })
end, { desc = "Show current Workspace Symbols" })
vim.keymap.set("n", "<leader>bs", function()
    require("telescope.builtin").lsp_document_symbols({ symbol_width = 60, symbol_type_width = 30, fname_width = 80 })
end, { desc = "Show symbols in document" })
vim.keymap.set("n", "<leader>br", function()
    require("telescope.builtin").lsp_references({ fname_width = 80 })
end, { desc = "Show references" })
vim.keymap.set("n", "<leader>bd", function()
    require("telescope.builtin").lsp_definitions({ jump_type = "vsplit", fname_width = 80 })
end, { desc = "Go to definition" })
vim.keymap.set("n", "<leader>bt", function()
    require("telescope.builtin").lsp_type_definitions({ fname_width = 80 })
end, { desc = "Go to type definition" })
vim.keymap.set("n", "<leader>bi", function()
    require("telescope.builtin").lsp_implementations({ fname_width = 80 })
end, { desc = "Go to implementation" })
vim.keymap.set("n", "<leader>be", function()
    require("telescope.builtin").diagnostics()
end, { desc = "Show diagnostics" })
