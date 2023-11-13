if not vim.g.vscode then
    vim.lsp.set_log_level("off")
    local lsp = require("lsp-zero")

    lsp.preset("recommended")
    lsp.setup_servers({ "csharp_ls", "bashls", 'cmake' })
    lsp.ensure_installed({
        -- 'clangd',
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
    local lspc = require("lspconfig")
    lspc.cmake.setup {
        cmd = { '/opt/homebrew/bin/cmake-language-server' },
        filetypes = {
            'cmake',
            'CMakeLists.txt'
        }
    }

    lspc.bashls.setup {
        filetypes = {
            'sh',
            'bash'
        }
    }

    lspc.lua_ls.setup {
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

    lsp.on_attach(function(client, bufnr)
        if client.server_capabilities.signatureHelpProvider then
            require('lsp-overloads').setup(client, {})
        end
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
    lspc.clangd.setup {
        capabilities = capabilities,
        cmd = { "/opt/homebrew/opt/llvm/bin/clangd", "--background-index" },
        filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp" },
        root_dir = function(fname)
            return lspc.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname) or vim.fn.getcwd()
        end,
        on_attach = function(client, bufnr) buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc') end
    }
    -- lspc.ccls.setup {
    --     capabilities = capabilities,
    --     cmd = { "ccls" },
    --     filetypes = { "c", "cpp", "objc", "objcpp", "cc" },
    --     root_dir = function(fname)
    --         return lspc.util.root_pattern("compile_commands.json", ".ccls", ".git")(fname) or vim.fn.getcwd()
    --     end,
    --     on_attach = function(client, bufnr) buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc') end
    -- }
end
