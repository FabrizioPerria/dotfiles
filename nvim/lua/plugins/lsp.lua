return {
    {
        "llllvvuu/nvim-cmp",
        dependencies = { "onsails/lspkind.nvim", "L3MON4D3/LuaSnip", "zbirenbaum/copilot.lua" },
        branch = "feat/above",
        event = "VeryLazy",
        opts = function()
            local cmp = require("cmp")
            require("cmp").setup({
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
                    ["<C-s>"] = cmp.mapping.complete({
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
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        dependencies = {
            "neovim/nvim-lspconfig",
            "llllvvuu/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            lsp_capabilities.offsetEncoding = "utf-16"
            local lsp_zero = require("lsp-zero")
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
                    -- clangd = function()
                    --     require("lspconfig").clangd.setup {
                    --         capabilities = lsp_capabilities,
                    --         cmd = { "clangd", "--background-index" },
                    --         filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp" },
                    --         root_dir = function(fname)
                    --             return require("lspconfig").util.root_pattern("compile_commands.json", "compile_flags.txt",
                    --                 ".git")(fname) or vim.fn.getcwd()
                    --         end,
                    --         on_attach = function(client, bufnr)
                    --             vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                    --         end
                    --     }
                    -- end,
                    -- gopls = function()
                    --     require("lspconfig").gopls.setup {
                    --         capabilities = lsp_capabilities,
                    --         cmd = { "gopls" },
                    --         filetypes = { "go", "gomod" },
                    --         root_dir = require("lspconfig").util.root_pattern("go.mod", ".git"),
                    --         on_attach = function(client, bufnr)
                    --             vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                    --         end,
                    --         settings = {
                    --             gopls = {
                    --                 analyses = {
                    --                     unusedparams = true,
                    --                     shadow = true,
                    --                 },
                    --                 staticcheck = true,
                    --                 completeUnimported = true,
                    --                 usePlaceholders = true,
                    --             },
                    --         },
                    --     }
                    -- end
                },
            })
        end,
        event = "VeryLazy",
    },
}
