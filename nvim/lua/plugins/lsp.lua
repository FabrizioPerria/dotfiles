return {
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
        },
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "llllvvuu/nvim-cmp",
            -- 'hrsh7th/nvim-cmp',
            'hrsh7th/cmp-nvim-lsp',
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "L3MON4D3/LuaSnip",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            local lsp_zero = require("lsp-zero").preset({
                manage_nvim_cmp = {
                    set_sources = "recommended",
                    set_basic_mappings = true,
                    set_extra_mappings = false,
                    use_luasnip = true,
                    set_format = true,
                    documentation_window = true,
                },
            })

            lsp_zero.on_attach(function(client, bufnr)
                vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
                vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set("n", "<leader>f", '<cmd> lua vim.lsp.buf.format()<cr>', opts)
                lsp_zero.default_keymaps({
                    buffer = bufnr,
                    exclude = {
                        "<F2>",
                        "<F4>",
                    },
                })
            end)

            require("mason").setup({})
            require("mason-lspconfig").setup({
                handlers = {
                    lsp_zero.default_setup,
                },
            })
            require('lspconfig').lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { 'vim' }
                        }
                    }
                }
            })
            require('lspconfig').gopls.setup({
                settings = {
                    gopls = {
                        gofumpt = true,
                        codelenses = {
                            gc_details = false,
                            generate = true,
                            regenerate_cgo = true,
                            run_govulncheck = true,
                            test = true,
                            tidy = true,
                            upgrade_dependency = true,
                            vendor = true,
                        },
                        hints = {
                            assignVariableTypes = true,
                            compositeLiteralFields = true,
                            compositeLiteralTypes = true,
                            constantValues = true,
                            functionTypeParameters = true,
                            parameterNames = true,
                            rangeVariableTypes = true,
                        },
                        analyses = {
                            fieldalignment = true,
                            nilness = true,
                            unusedparams = true,
                            unusedwrite = true,
                            useany = true,
                        },
                        usePlaceholders = true,
                        completeUnimported = true,
                        staticcheck = true,
                        directoryFilters = { "-.git", "-.vscode", "-.idea", "-.vscode-test", "-node_modules" },
                        semanticTokens = true,
                        -- },
                    },
                },
            })
        end,
        -- event = "VeryLazy",
    },
    {
        "llllvvuu/nvim-cmp",
        branch = "feat/above",
        -- "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "onsails/lspkind.nvim",
            'saadparwaiz1/cmp_luasnip',
            "L3MON4D3/LuaSnip",
            "zbirenbaum/copilot.lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline"
        },
        -- event = "VeryLazy",
        lazy = true,
        config = function()
            require("luasnip/loaders/from_vscode").lazy_load()
        end,
        opts = function()
            local cmp = require("cmp")
            require("cmp").setup({
                completion = {
                    -- autocomplete = false
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "symbol_text",  -- show only symbol annotations
                        maxwidth = 80,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                        ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
                    }),
                },
                view = {
                    entries = {
                        name = "custom",
                        selection_order = "top_down",
                        vertical_positioning = "above",
                    },
                    docs = {
                        auto_open = true,
                    },
                },
                window = {
                    documentation = cmp.config.window.bordered(),
                    completion = cmp.config.window.bordered(),
                },
                sources = {
                    { name = "luasnip" },
                    { name = "path" },
                    { name = "nvim_lsp" },
                    { name = "buffer" },
                    { name = "nvim_lua" },
                },
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },

                mapping = cmp.mapping.preset.insert({
                    ["Up"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    ["Down"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    ["<CR>"] = cmp.mapping.confirm({
                        select = true,
                    }),
                    ["<S-Tab>"] = cmp.mapping.complete({
                        -- ["<C-Space>"] = cmp.mapping.complete({
                        reason = cmp.ContextReason.Auto,
                    }),
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
                    end, { "i", "s" }),
                }),
            })
        end,
    },
}
