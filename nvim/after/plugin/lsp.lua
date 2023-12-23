if not vim.g.vscode then
    local lspkind = require('lspkind')
    lspkind.init({
        symbol_map = {
            Copilot = "",
        },
    })

    vim.lsp.set_log_level("off")
    local lsp_zero = require("lsp-zero")
    lsp_zero.set_preferences({ suggest_lsp_servers = true, })

    lsp_zero.set_sign_icons({
        error = "",
        warn = "",
        hint = "",
        info = ""
    })

    lsp_zero.on_attach(function(client, bufnr)
        if client.server_capabilities.signatureHelpProvider then
            require('lsp-overloads').setup(client, {})
        end
    end)

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.offsetEncoding = 'utf-8'

    require('mason').setup({})
    require('mason-lspconfig').setup({
        ensure_installed = {
            'clangd',
            'cmake',
            'bashls',
            'cmake',
            'pyright',
            'zk',
            'lua_ls',
            'vimls',
            'efm',
            'csharp_ls',
            'grammarly',
            -- 'clang-format',
            -- 'codelldb',
            -- 'cpptools',
            -- 'debugpy',
            -- 'glow',
            -- 'netcoredbg',
            -- 'prettier',
            -- 'shfmt',
            -- 'stylua',
        },
        handlers = {
            lsp_zero.default_setup,
            bashls = function()
                require("lspconfig").bashls.setup {
                    filetypes = {
                        'sh',
                        'bash'
                    }
                }
            end,
            cmake = function()
                require("lspconfig").cmake.setup {
                    cmd = { '/opt/homebrew/bin/cmake-language-server' },
                    filetypes = {
                        'cmake',
                        'CMakeLists.txt'
                    }
                }
            end,
            lua_ls = function()
                require("lspconfig").lua_ls.setup {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { 'vim' }
                            }
                        }
                    }
                }
            end,
            clangd = function()
                require("lspconfig").clangd.setup {
                    capabilities = capabilities,
                    cmd = { "/opt/homebrew/opt/llvm/bin/clangd", "--background-index" },
                    filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp" },
                    root_dir = function(fname)
                        return require("lspconfig").util.root_pattern("compile_commands.json", "compile_flags.txt",
                            ".git")(fname) or vim.fn.getcwd()
                    end,
                    on_attach = function(client, bufnr)
                        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                    end
                }
            end,
            gopls = function()
                require("lspconfig").gopls.setup {
                    cmd = { "/opt/homebrew/bin/gopls" },
                    filetypes = { "go", "gomod" },
                    root_dir = require("lspconfig").util.root_pattern("go.mod", ".git"),
                    on_attach = function(client, bufnr)
                        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                    end
                }
            end,
        }
    })

    vim.g.copilot_no_tab_map = true
    vim.g.copilot_assume_mapped = true
    vim.g.copilot_tab_fallback = ""
    -- require("copilot_cmp").setup()
    local cmp = require('cmp')
    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
        sources = {
            { name = "copilot",  group_index = 2 },
            { name = "nvim_lsp", group_index = 2 },
            { name = "path",     group_index = 2 },
            { name = "luasnip",  group_index = 2 },
        },

        view = {
            entries = {
                name = 'custom',
                selection_order = 'top_down',
                vertical_positioning = 'above',
            },
            docs = {
                auto_open = true,
            },
        },

        mapping = cmp.mapping.preset.insert({
            ['Up'] = cmp.mapping.select_prev_item(cmp_select),
            ['Down'] = cmp.mapping.select_next_item(cmp_select),
            ['<CR>'] = cmp.mapping.confirm({ select = true }),
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

        }),

        formatting = {
            format = lspkind.cmp_format({
                mode = 'symbol_text',  -- show only symbol annotations
                maxwidth = 80,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                ellipsis_char = '...', -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            })
        },
    })

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


    require "lsp_signature".setup({
        bind = true, -- This is mandatory, otherwise border config won't get registered.
        handler_opts = {
            border = "rounded"
        }
    })
end
