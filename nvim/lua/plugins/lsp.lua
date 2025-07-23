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
                "<leader>fo",
                function()
                    require("conform").format({ async = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
                python = { "autopep8", "ruff" },
                javascript = { "prettierd", "prettier", stop_after_first = true },
                typescript = { "prettierd", "prettier", stop_after_first = true },
                json = { "prettierd", "prettier" },
                yaml = { "prettierd", "prettier" },
                markdown = { "prettierd", "prettier" },
                html = { "prettierd", "prettier" },
            },
            default_format_opts = {
                lsp_format = "never",
            },
            format_on_save = { timeout_ms = 1000 },
            formatters = {
                shfmt = {
                    prepend_args = { "-i", "4" },
                },
            },
        },
        init = function()
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
    { "mfussenegger/nvim-jdtls" },
    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
            "llllvvuu/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "williamboman/mason.nvim",
            "neovim/nvim-lspconfig",
            "L3MON4D3/LuaSnip",
            "luckasRanarison/clear-action.nvim",
            "aznhe21/actions-preview.nvim",
        },
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            require("mason").setup()
            local lspconfig = require("lspconfig")
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "bashls",
                    "basedpyright",
                    "ruff",
                    "gopls",
                    "cmake",
                    "lua_ls",
                    "jsonls",
                    "yamlls",
                    "marksman",
                    "ansiblels",
                    "docker_compose_language_service",
                    "dockerls",
                    "dotls",
                    "cssls",
                    "ts_ls",
                    "tailwindcss",
                    "eslint",
                    "vue_ls",
                    "jdtls",
                    -- NOTE: java is handled separately
                },
                automatic_enable = {
                    exclude = {
                        "lua_ls",
                        "jdtls",
                        "ts_ls",
                        "vue_ls",
                    },
                },
            })
            local vue_language_server =
                vim.fn.expand("$MASON/packages/vue-language-server/node_modules/@vue/language-server")

            lspconfig.ts_ls.setup({
                init_options = {
                    plugins = {
                        {
                            name = "@vue/typescript-plugin",
                            location = vue_language_server,
                            languages = { "vue" },
                        },
                    },
                },
                filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
                settings = {
                    typescript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                    javascript = {
                        inlayHints = {
                            includeInlayParameterNameHints = "all",
                            includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                            includeInlayFunctionParameterTypeHints = true,
                            includeInlayVariableTypeHints = true,
                            includeInlayVariableTypeHintsWhenTypeMatchesName = true,
                            includeInlayPropertyDeclarationTypeHints = true,
                            includeInlayFunctionLikeReturnTypeHints = true,
                            includeInlayEnumMemberValueHints = true,
                        },
                    },
                },
                root_dir = require("lspconfig.util").root_pattern("package.json", "vue.config.js", "vite.config.ts"),
            })
            lspconfig.lua_ls.setup({
                settings = {
                    Lua = {
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                        telemetry = {
                            enable = false,
                        },
                    },
                },
            })
        end,
    },
    {
        "llllvvuu/nvim-cmp",
        branch = "feat/above",
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
            require("luasnip/loaders/from_vscode").lazy_load()
            require("luasnip/loaders/from_snipmate").lazy_load()
            require("luasnip_snippets.common.snip_utils").setup()
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
                    { name = "nvim_lsp", priority = 1000 },
                    { name = "luasnip", priority = 750 },
                    { name = "buffer", priority = 500 },
                    { name = "path", priority = 250 },
                    { name = "nvim_lua", priority = 750 },
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
