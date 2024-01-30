if not vim.g.vscode then
    local lspkind = require('lspkind')
    lspkind.init({
        symbol_map = {
            Copilot = "",
        },
    })

    vim.api.nvim_create_autocmd('LspAttach', {
        desc = 'LSP keybindings',
        callback = function(event)
            local opts = { buffer = event.buf }
            vim.keymap.set("n", "gd", function() vim.lsp.buf.definition() end, opts)
            vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
            vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
            vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
            vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
            vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
            vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
        end
    })

    local lspconfig = require('lspconfig')
    local lsp_capabilities = require('cmp_nvim_lsp').default_capabilities()
    lsp_capabilities.offsetEncoding = 'utf-8'

    require('mason').setup({})
    require('mason-tool-installer').setup({
        ensure_installed = {
            'pyright',
            'mypy',
            'ruff',
            'black',
            'debugpy',

            'clangd',
            'clang-format',
            'codelldb',
            'cmake-language-server',

            'gopls',

            'stylua',

            "json-lsp",
            "jsonlint",
            "jq",
            "yaml-language-server",
            "yamllint",
            "yamlfmt",

            "commitlint",
            "gitlint",

            "marksman",
            "markdownlint",
            "vale",
            "write-good",
            "cspell",
            "misspell",
            "proselint",

            "bash-language-server",
            "beautysh",
            "shfmt",
            "shellcheck",
            "shellharden",

            "ansible-language-server",
            "css-lsp",
            "codespell",
            "dockerfile-language-server",
            "dot-language-server",
            "editorconfig-checker",
            "html-lsp",

            "csharp-language-server"
        },
        handlers = {
            function(server)
                lspconfig[server].setup({
                    capabilities = lsp_capabilities,
                })
            end,
        }
    })
    require("lspconfig").bashls.setup {
        filetypes = {
            'sh',
            'bash'
        }
    }
    require("lspconfig").cmake.setup {
        cmd = { '/opt/homebrew/bin/cmake-language-server' },
        filetypes = {
            'cmake',
            'CMakeLists.txt'
        }
    }

    require("lspconfig").lua_ls.setup {
        settings = {
            Lua = {
                diagnostics = {
                    globals = { 'vim' }
                }
            }
        }
    }
    require("lspconfig").clangd.setup {
        capabilities = lsp_capabilities,
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
    require("lspconfig").gopls.setup {
        cmd = { "/opt/homebrew/bin/gopls" },
        filetypes = { "go", "gomod" },
        root_dir = require("lspconfig").util.root_pattern("go.mod", ".git"),
        on_attach = function(client, bufnr)
            vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
        end
    }

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

        window = {
            documentation = cmp.config.window.bordered(),
        },
        snippet = {
            expand = function(args)
                require('luasnip').lsp_expand(args.body)
            end,
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
