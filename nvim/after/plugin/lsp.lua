if not vim.g.vscode then
    vim.lsp.set_log_level("debug")
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
        'efm'
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

    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }
    local cmp_mappings = lsp.defaults.cmp_mappings({
        ['Up'] = cmp.mapping.select_prev_item(cmp_select),
        ['Down'] = cmp.mapping.select_next_item(cmp_select),
        ['Enter'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<Tab>'] = nil,
        ['<S-Tab>'] = nil
    })

    lsp.setup_nvim_cmp({
        mapping = cmp_mappings,
        formatting = {
            format = function(entry, vim_item)
                -- vim_item.abbr = string.sub(vim_item.abbr, 1, 40)
                return vim_item
            end
        }
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

    lsp.on_attach(function(client, bufnr)
        if client.server_capabilities.signatureHelpProvider then
            require('lsp-overloads').setup(client, {})
        end
        vim.keymap.set("i", "<C-s>", function() vim.lsp.buf.signature_help() end,
            { desc = "Signature help", buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>.", require("actions-preview").code_actions,
            { desc = 'Code Actions', buffer = bufnr, remap = false })
        -- vim.keymap.set("n", "<leader>vwf", function() vim.lsp.buf.list_workspace_folders() end, { buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>vS",
            function()
                require('telescope.builtin').lsp_dynamic_workspace_symbols({
                    symbol_width = 60,
                    symbol_type_width = 30,
                    fname_width = 50
                })
            end,
            { buffer = bufnr, remap = false, desc = "Show current Workspace Symbols" })
        vim.keymap.set("n", "<leader>vs",
            function()
                require('telescope.builtin').lsp_document_symbols({
                    symbol_width = 60,
                    symbol_type_width = 30,
                    fname_width = 80
                })
            end, { desc = "Show symbols in document", buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>vr",
            function() require('telescope.builtin').lsp_references({ fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Show references" })
        vim.keymap.set("n", "<leader>vd",
            function() require('telescope.builtin').lsp_definitions({ jump_type = 'vsplit', fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Go to definition" })
        vim.keymap.set("n", "<leader>vt",
            function() require('telescope.builtin').lsp_type_definitions({ fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Go to type definition" })
        vim.keymap.set("n", "<leader>vi",
            function() require('telescope.builtin').lsp_implementations({ fname_width = 80 }) end,
            { buffer = bufnr, remap = false, desc = "Go to implementation" })

        vim.keymap.set("n", "<leader>;", function() vim.lsp.buf.hover() end,
            { buffer = bufnr, remap = false, desc = 'Hover' })
        -- vim.keymap.set("n", "<leader>:", function() vim.lsp.buf.implementation() end, { buffer = bufnr, remap = false })
        vim.keymap.set("n", "<leader>vrn", ":lua vim.lsp.buf.rename()<CR>",
            { desc = "rename symbol", buffer = bufnr, remap = false })
        -- vim.keymap.set("n", "gD", function() vim.lsp.buf.declaration() end, { buffer = bufnr, remap = false })
        -- vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, { buffer = bufnr, remap = false })
        vim.keymap.set('n', '<leader>dd',
            function() if vim.diagnostic.is_disabled() then vim.diagnostic.enable() else vim.diagnostic.disable() end end,
            { desc = "Toggle diagnostics" })
        vim.keymap.set("n", "<leader>vD", function() vim.diagnostic.open_float() end,
            { buffer = bufnr, remap = false, desc = "Show diagnostics window" })
        -- vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, { buffer = bufnr, remap = false })
        -- vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, { buffer = bufnr, remap = false })
    end)

    lsp.setup({})

    vim.diagnostic.config({
        virtual_text = true
    })

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = 'utf-8'
    require('lspconfig').clangd.setup {
        capabilities = capabilities
    }
end
