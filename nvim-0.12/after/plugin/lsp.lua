function ShowDiagnosticsHover()
    local opts = {
        focusable = false,
        close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
        border = "rounded",
        source = "if_many",
        scope = "line",
        max_width = 80,
        max_height = 15,
        float_opts = {
            winblend = 0,
            highlight = { bg = "#1e222a" },
        },
    }

    local float_bufnr, float_winnr = vim.diagnostic.open_float(nil, opts)

    if float_winnr and vim.api.nvim_win_is_valid(float_winnr) then
        vim.api.nvim_win_set_option(float_winnr, "wrap", true)
        vim.api.nvim_win_set_option(float_winnr, "linebreak", true)
    end
end

local function enable_completion(client, bufnr)
    if client and client:supports_method("textDocument/completion") then
        vim.lsp.completion.enable(true, client.id, bufnr, { autotrigger = true })
    end
end

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_completion", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        enable_completion(client, args.buf)
        -- Trigger completion on every keypress, not just triggerCharacters
        vim.api.nvim_create_autocmd("InsertCharPre", {
            buffer = args.buf,
            callback = function()
                vim.lsp.completion.get()
            end,
        })
        vim.keymap.set("n", "<leader>a", function()
            require("actions-preview").code_actions()
        end, {})
        vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", {})
        vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", {})
        vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", {})
        vim.keymap.set("n", "K", function()
            local ok_dap, dap = pcall(require, "dap")
            local ok_dapui, dapui = pcall(require, "dapui")
            if ok_dap and ok_dapui and dap.session() then
                dapui.eval()
            else
                vim.lsp.buf.hover()
            end
        end, { desc = "Context-aware hover (DAP/LSP)" })
        vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", {})
        vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", {})
        vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", {})
        vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", {})
        vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", {})
        vim.keymap.set("n", "gu", "<cmd>lua vim.lsp.buf.references()<cr>", {})
        vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", {})
        vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", {})

        vim.keymap.set("n", "<M-S-K>", ShowDiagnosticsHover, { desc = "Show diagnostic hover" })

        vim.diagnostic.config({
            underline = false,
            virtual_text = {
                spacing = 0,
                prefix = "●",
                format = function(diagnostic)
                    return ""
                end,
                hl_mode = "blend",
                virt_text_pos = "right_align",
            },
            update_in_insert = false,
            severity_sort = true,
            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = " ",
                    [vim.diagnostic.severity.WARN] = " ",
                    [vim.diagnostic.severity.HINT] = " ",
                    [vim.diagnostic.severity.INFO] = " ",
                },
            },
        })
        vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", {})
        vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", {})
    end,
})

vim.lsp.enable({
    "ansiblels",
    "basedpyright",
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "dotls",
    "gopls",
    "jdtls",
    "jsonls",
    "kotlin_language_server",
    "lua_ls",
    "marksman",
    "powershell_es",
    -- "roslyn",
    "tailwindcss",
    "ts_ls",
    "yamlls",
})

-- Enable completion for any clients that attached before this file was sourced
for _, client in ipairs(vim.lsp.get_clients()) do
    for bufnr in pairs(client.attached_buffers) do
        enable_completion(client, bufnr)
    end
end
