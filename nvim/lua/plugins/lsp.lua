local is_java_project = require("config.utils").is_java_project()

return {
    {
        "L3MON4D3/LuaSnip",
        lazy = true,
        build = "make install_jsregexp",
        dependencies = {
            "rafamadriz/friendly-snippets",
            "mireq/luasnip-snippets",
        },
    },
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                -- Customize or remove this keymap to your liking
                "<leader>fo",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        -- This will provide type hinting with LuaLS
        ---@module "conform"
        ---@type conform.setupOpts
        opts = {
            -- Define your formatters
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "autopep8", "ruff" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
            },
            -- Set default options
            default_format_opts = {
                lsp_format = "fallback",
            },
            -- Set up format-on-save
            format_on_save = { timeout_ms = 1000 },
            -- Customize formatters
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "4" },
                },
            },
        },
        init = function()
            -- If you want the formatexpr, here is the place to set it
            vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvimtools/none-ls-extras.nvim",
        },
        event = "VeryLazy",
        opts = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.code_actions.proselint,
                    null_ls.builtins.code_actions.refactoring,
                    -- null_ls.builtins.code_actions.textlint,
                    null_ls.builtins.completion.luasnip,

                    null_ls.builtins.diagnostics.codespell,
                    null_ls.builtins.diagnostics.markdownlint,
                    null_ls.builtins.diagnostics.write_good,
                    null_ls.builtins.diagnostics.dotenv_linter,
                    null_ls.builtins.diagnostics.sqlfluff.with({
                        extra_args = { "--dialect", "postgres" }, -- change to your dialect
                    }),
                    null_ls.builtins.diagnostics.yamllint,
                    null_ls.builtins.diagnostics.zsh,
                    null_ls.builtins.completion.spell,
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "llllvvuu/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "L3MON4D3/LuaSnip",
            "luckasRanarison/clear-action.nvim",
            "aznhe21/actions-preview.nvim",
            "fabrizioperria/nvim-java",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            if is_java_project then
                require("java").setup()
            end
            local lspconfig = require("lspconfig")
            require("mason").setup({})
            local lsp_attach_custom = function(client, bufnr)
                local opts = { buffer = bufnr }
                vim.keymap.set("n", "<leader>a", function()
                    require("actions-preview").code_actions()
                end, opts)
                vim.keymap.set("n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
                -- vim.keymap.set("n", "<leader>fo", "<cmd> lua vim.lsp.buf.format()<cr>", opts)
                vim.keymap.set("n", "<leader>li", "<cmd>LspInfo<cr>", opts)
                vim.keymap.set("n", "<leader>lr", "<cmd>LspRestart<cr>", opts)
                vim.keymap.set("n", "K", "<cmd>lua vim.lsp.buf.hover()<cr>", opts)
                vim.keymap.set("n", "gd", "<cmd>lua vim.lsp.buf.definition()<cr>", opts)
                vim.keymap.set("n", "gD", "<cmd>lua vim.lsp.buf.declaration()<cr>", opts)
                vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<cr>", opts)
                vim.keymap.set("n", "go", "<cmd>lua vim.lsp.buf.type_definition()<cr>", opts)
                vim.keymap.set("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
                vim.keymap.set("n", "gs", "<cmd>lua vim.lsp.buf.signature_help()<cr>", opts)
                vim.keymap.set({ "n", "x" }, "<F3>", "<cmd>lua vim.lsp.buf.format({async = true})<cr>", opts)

                vim.keymap.set("n", "gl", "<cmd>lua vim.diagnostic.open_float()<cr>", opts)
                vim.keymap.set("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<cr>", opts)
                vim.keymap.set("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<cr>", opts)
            end
            local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()
            require("mason-lspconfig").setup({
                handlers = {
                    function(server_name)
                        if server_name == "jdtls" and not is_java_project then
                            return
                        end
                        lspconfig[server_name].setup({
                            on_attach = lsp_attach_custom,
                            capabilities = lsp_capabilities,
                        })
                    end,
                },
            })
            lspconfig.lua_ls.setup({
                on_attach = lsp_attach_custom,
                capabilities = lsp_capabilities,
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                    },
                },
            })
            -- lspconfig.pylsp.setup({
            --     on_attach = lsp_attach_custom,
            --     capabilities = lsp_capabilities,
            --     settings = {
            --         pylsp = {
            --             plugins = {
            --                 pyflakes = { enabled = false },
            --                 pycodestyle = { enabled = false },
            --                 autopep8 = { enabled = false },
            --                 yapf = { enabled = false },
            --                 mccabe = { enabled = false },
            --                 pylsp_mypy = { enabled = false },
            --                 pylsp_black = { enabled = false },
            --                 pylsp_isort = { enabled = true },
            --                 rope_autoimport = { enabled = true },
            --                 pylint = { enabled = true, executable = "pylint" },
            --                 jedi_completion = { fuzzy = true },
            --                 pyls_isort = { enabled = true },
            --             },
            --         },
            --     },
            -- })
            lspconfig.gopls.setup({
                on_attach = lsp_attach_custom,
                capabilities = lsp_capabilities,
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
            "saadparwaiz1/cmp_luasnip",
            "L3MON4D3/LuaSnip",
            "zbirenbaum/copilot.lua",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-cmdline",
        },
        -- event = "VeryLazy",
        lazy = true,
        config = function()
            -- require("luasnip/loaders/from_vscode").lazy_load()
            -- require("luasnip/loaders/from_snipmate").lazy_load()
            -- require("luasnip_snippets.common.snip_utils").setup()
        end,
        opts = function()
            local cmp = require("cmp")
            require("cmp").setup({
                preselect = "none",
                completion = {
                    completeopt = "menu,menuone,noinsert,noselect",
                },
                formatting = {
                    format = require("lspkind").cmp_format({
                        mode = "symbol_text", -- show only symbol annotations
                        maxwidth = 80, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
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
                    ["<Up>"] = cmp.mapping.select_prev_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    ["<Down>"] = cmp.mapping.select_next_item({
                        behavior = cmp.SelectBehavior.Select,
                    }),
                    ["<Enter>"] = cmp.mapping.confirm({
                        behavior = cmp.ConfirmBehavior.Insert,
                        select = false,
                    }),
                    ["<C-j>"] = cmp.mapping.scroll_docs(4),
                    ["<C-k>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-d>"] = cmp.mapping.scroll_docs(4),
                    ["<C-u>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-Space>"] = cmp.mapping.complete(),
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
