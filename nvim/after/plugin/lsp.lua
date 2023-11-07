if not vim.g.vscode then
    vim.lsp.set_log_level("off")
    local lsp = require("lsp-zero")

    lsp.preset("recommended")
    lsp.setup_servers({ "csharp_ls", "bashls", 'cmake' })
    lsp.ensure_installed({
        'clangd',
        'cmake',
        'bashls',
        'cmake',
        'pyright',
        'zk',
        'lua_ls',
        'vimls',
        'efm',
    })

    -- Fix Undefined global 'vim'
    lsp.nvim_workspace()

    require 'lspconfig'.cmake.setup {
        cmd = { '/opt/homebrew/bin/cmake-language-server' },
        filetypes = {
            'cmake',
            'CMakeLists.txt'
        }
    }

    require 'lspconfig'.bashls.setup {
        filetypes = {
            'sh',
            'bash'
        }
    }

    require 'lspconfig'.lua_ls.setup {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    }

    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
        ['Up'] = cmp.mapping.select_prev_item(cmp_select),
        ['Down'] = cmp.mapping.select_next_item(cmp_select),
        ['Enter'] = cmp.mapping.confirm({ select = true }),
        ["<C-s>"] = cmp.mapping.complete({ reason = cmp.ContextReason.Auto }),
        ["<C-j>"] = cmp.mapping.scroll_docs(4),
        ["<C-k>"] = cmp.mapping.scroll_docs(-4),
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
        ["<C-e>"] = cmp.mapping.close(),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if require("copilot.suggestion").is_visible() then
                require("copilot.suggestion").accept()
            else
                fallback()
            end
        end, { "i", "s", }),
    })


    local lspkind = require('lspkind')
    lspkind.init({
        symbol_map = {
            Copilot = "",
        },
    })

    lsp.setup_nvim_cmp({
        sources = {
            { name = 'nvim_lsp' },
        },

        mapping = cmp_mappings,

        formatting = {
            format = lspkind.cmp_format({
                mode = 'symbol_text',  -- show only symbol annotations
                maxwidth = 80,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            })
        },

    })

    lsp.set_preferences({
        suggest_lsp_servers = true,
        sign_icons = {
            error = 'E',
            warn = 'W',
            hint = 'H',
            info = 'I'
        }
    })

    local telescopeBI = require('telescope.builtin')
    lsp.on_attach(function(client, bufnr)
        if client.server_capabilities.signatureHelpProvider then
            require('lsp-overloads').setup(client, {})
        end
        vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help,
            { desc = "Signature help", buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>.", require("actions-preview").code_actions,
            { desc = 'Code Actions', buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>vS",
            function()
                telescopeBI.lsp_dynamic_workspace_symbols({
                    symbol_width = 60,
                    symbol_type_width = 30,
                    fname_width = 50
                })
            end,
            { buffer = bufnr, remap = false, desc = "Show current Workspace Symbols" })
        vim.keymap.set("n", "<leader>vs",
            function()
                telescopeBI.lsp_document_symbols({
                    symbol_width = 60,
                    symbol_type_width = 30,
                    fname_width = 80
                })
            end, { desc = "Show symbols in document", buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>vr",
            function() telescopeBI.lsp_references({ fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Show references" })
        vim.keymap.set("n", "<leader>vd",
            function() telescopeBI.lsp_definitions({ jump_type = 'vsplit', fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>vt",
            function() telescopeBI.lsp_type_definitions({ fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Go to type definition" })
        vim.keymap.set("n", "<leader>vi",
            function() telescopeBI.lsp_implementations({ fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Go to implementation" })

        vim.keymap.set("n", "<leader>;", vim.lsp.buf.hover, { buffer = bufnr, remap = false, desc = 'Hover' })
        vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, { desc = "rename symbol", buffer = bufnr, remap = false })
        vim.keymap.set('n', '<leader>dd',
            function() if vim.diagnostic.is_disabled() then vim.diagnostic.enable() else vim.diagnostic.disable() end end,
            { desc = "Toggle diagnostics" })
        vim.keymap.set("n", "<leader>ve", telescopeBI.diagnostics,
            { buffer = bufnr, remap = false, desc = "Show diagnostics" })
        vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { buffer = bufnr, remap = false, desc = 'Next diagnostic' })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { buffer = bufnr, remap = false, desc = 'Prev diagnostic' })
    end)

    lsp.setup({})

    vim.diagnostic.config({
        underline = true,
        signs = true,
        virtual_text = true,
        float = {
            show_header = true,
            source = 'always',
            border = 'rounded',
            focusable = false,
        },
        update_in_insert = false, -- default to false
        severity_sort = false,    -- default to false
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = 'utf-8'
    require('lspconfig').clangd.setup {
        capabilities = capabilities
    }
end
