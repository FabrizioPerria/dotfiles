return {
    {
        "mfussenegger/nvim-jdtls",
        dependencies = { "folke/which-key.nvim" },
        ft = java_filetypes,
        opts = function()
            local mason_registry = require("mason-registry")
            local lombok_jar = mason_registry.get_package("jdtls"):get_install_path() .. "/lombok.jar"
            return {
                -- How to find the root dir for a given filename. The default comes from
                -- lspconfig which provides a function specifically for java projects.
                root_dir = require("lspconfig.server_configurations.jdtls").default_config.root_dir,

                -- How to find the project name for a given root dir.
                project_name = function(root_dir)
                    return root_dir and vim.fs.basename(root_dir)
                end,

                -- Where are the config and workspace dirs for a project?
                jdtls_config_dir = function(project_name)
                    return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
                end,
                jdtls_workspace_dir = function(project_name)
                    return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
                end,

                -- How to run jdtls. This can be overridden to a full java command-line
                -- if the Python wrapper script doesn't suffice.
                cmd = {
                    vim.fn.exepath("jdtls"),
                    string.format("--jvm-arg=-javaagent:%s", lombok_jar),
                },
                full_cmd = function(opts)
                    local fname = vim.api.nvim_buf_get_name(0)
                    local root_dir = opts.root_dir(fname)
                    local project_name = opts.project_name(root_dir)
                    local cmd = vim.deepcopy(opts.cmd)
                    if project_name then
                        vim.list_extend(cmd, {
                            "-configuration",
                            opts.jdtls_config_dir(project_name),
                            "-data",
                            opts.jdtls_workspace_dir(project_name),
                        })
                    end
                    return cmd
                end,

                -- These depend on nvim-dap, but can additionally be disabled by setting false here.
                dap = { hotcodereplace = "auto", config_overrides = {} },
                dap_main = {},
                test = true,
                settings = {
                    java = {
                        inlayHints = {
                            parameterNames = {
                                enabled = "all",
                            },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            -- Find the extra bundles that should be passed on the jdtls command-line
            -- if nvim-dap is enabled with java debug/test.
            local mason_registry = require("mason-registry")
            local bundles = {} ---@type string[]
            if opts.dap and LazyVim.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
                local java_dbg_pkg = mason_registry.get_package("java-debug-adapter")
                local java_dbg_path = java_dbg_pkg:get_install_path()
                local jar_patterns = {
                    java_dbg_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar",
                }
                -- java-test also depends on java-debug-adapter.
                if opts.test and mason_registry.is_installed("java-test") then
                    local java_test_pkg = mason_registry.get_package("java-test")
                    local java_test_path = java_test_pkg:get_install_path()
                    vim.list_extend(jar_patterns, {
                        java_test_path .. "/extension/server/*.jar",
                    })
                end
                for _, jar_pattern in ipairs(jar_patterns) do
                    for _, bundle in ipairs(vim.split(vim.fn.glob(jar_pattern), "\n")) do
                        table.insert(bundles, bundle)
                    end
                end
            end

            local function attach_jdtls()
                local fname = vim.api.nvim_buf_get_name(0)

                -- Configuration can be augmented and overridden by opts.jdtls
                local config = extend_or_override({
                    cmd = opts.full_cmd(opts),
                    root_dir = opts.root_dir(fname),
                    init_options = {
                        bundles = bundles,
                    },
                    settings = opts.settings,
                    -- enable CMP capabilities
                    capabilities = LazyVim.has("cmp-nvim-lsp") and require("cmp_nvim_lsp").default_capabilities() or nil,
                }, opts.jdtls)

                -- Existing server will be reused if the root_dir matches.
                require("jdtls").start_or_attach(config)
                -- not need to require("jdtls.setup").add_commands(), start automatically adds commands
            end

            -- Attach the jdtls for each java buffer. HOWEVER, this plugin loads
            -- depending on filetype, so this autocmd doesn't run for the first file.
            -- For that, we call directly below.
            vim.api.nvim_create_autocmd("FileType", {
                pattern = java_filetypes,
                callback = attach_jdtls,
            })

            -- Setup keymap and dap after the lsp is fully attached.
            -- https://github.com/mfussenegger/nvim-jdtls#nvim-dap-configuration
            -- https://neovim.io/doc/user/lsp.html#LspAttach
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client and client.name == "jdtls" then
                        local wk = require("which-key")
                        wk.add({
                            {
                                mode = "n",
                                buffer = args.buf,
                                { "<leader>cx",  group = "extract" },
                                { "<leader>cxv", require("jdtls").extract_variable_all, desc = "Extract Variable" },
                                { "<leader>cxc", require("jdtls").extract_constant,     desc = "Extract Constant" },
                                { "gs",          require("jdtls").super_implementation, desc = "Goto Super" },
                                { "gS",          require("jdtls.tests").goto_subjects,  desc = "Goto Subjects" },
                                { "<leader>co",  require("jdtls").organize_imports,     desc = "Organize Imports" },
                            },
                        })
                        wk.add({
                            {
                                mode = "v",
                                buffer = args.buf,
                                { "<leader>cx", group = "extract" },
                                {
                                    "<leader>cxm",
                                    [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
                                    desc = "Extract Method",
                                },
                                {
                                    "<leader>cxv",
                                    [[<ESC><CMD>lua require('jdtls').extract_variable_all(true)<CR>]],
                                    desc = "Extract Variable",
                                },
                                {
                                    "<leader>cxc",
                                    [[<ESC><CMD>lua require('jdtls').extract_constant(true)<CR>]],
                                    desc = "Extract Constant",
                                },
                            },
                        })

                        if opts.dap and LazyVim.has("nvim-dap") and mason_registry.is_installed("java-debug-adapter") then
                            -- custom init for Java debugger
                            require("jdtls").setup_dap(opts.dap)
                            require("jdtls.dap").setup_dap_main_class_configs(opts.dap_main)

                            -- Java Test require Java debugger to work
                            if opts.test and mason_registry.is_installed("java-test") then
                                -- custom keymaps for Java test runner (not yet compatible with neotest)
                                wk.add({
                                    {
                                        mode = "n",
                                        buffer = args.buf,
                                        { "<leader>t",  group = "test" },
                                        {
                                            "<leader>tt",
                                            function()
                                                require("jdtls.dap").test_class({
                                                    config_overrides = type(opts.test) ~= "boolean" and
                                                        opts.test.config_overrides or nil,
                                                })
                                            end,
                                            desc = "Run All Test",
                                        },
                                        {
                                            "<leader>tr",
                                            function()
                                                require("jdtls.dap").test_nearest_method({
                                                    config_overrides = type(opts.test) ~= "boolean" and
                                                        opts.test.config_overrides or nil,
                                                })
                                            end,
                                            desc = "Run Nearest Test",
                                        },
                                        { "<leader>tT", require("jdtls.dap").pick_test, desc = "Run Test" },
                                    },
                                })
                            end
                        end

                        -- User can set additional keymaps in opts.on_attach
                        if opts.on_attach then
                            opts.on_attach(args)
                        end
                    end
                end,
            })

            -- Avoid race condition by calling attach the first time, since the autocmd won't fire.
            attach_jdtls()
        end,
    },

    -- {
    --     "nvim-java/nvim-java",
    --     config = false,
    --     dependencies = {
    --         "neovim/nvim-lspconfig",
    --         'nvim-java/lua-async-await',
    --         'nvim-java/nvim-java-core',
    --         'nvim-java/nvim-java-test',
    --         'nvim-java/nvim-java-dap',
    --         'MunifTanjim/nui.nvim',
    --     },
    -- },
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
            'hrsh8th/cmp-nvim-lsp',
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "L3MON4D3/LuaSnip",
            "luckasRanarison/clear-action.nvim",
            "aznhe21/actions-preview.nvim",
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
                local opts = { buffer = bufnr }
                vim.keymap.set('n', '<leader>a', function() require("actions-preview").code_actions() end, opts)
                vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                vim.keymap.set("n", "<leader>fo", '<cmd> lua vim.lsp.buf.format()<cr>', opts)
                vim.keymap.set("n", "<leader>li", '<cmd>LspInfo<cr>', opts)
                vim.keymap.set("n", "<leader>lr", '<cmd>LspRestart<cr>', opts)
                vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
                vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                vim.keymap.set({ 'n', 'x' }, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)

                vim.keymap.set('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', opts)
                vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', opts)
                vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', opts)
            end)

            require("mason").setup({})
            -- require('java').setup({
            --     root_markers = {
            --         "settings.gradle",
            --         "settings.gradle.kts",
            --         "pom.xml",
            --         "build.gradle",
            --         "mvnw",
            --         "gradlew",
            --         "build.gradle",
            --         "build.gradle.kts",
            --     },
            -- })
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
            -- require('lspconfig').jdtls.setup({
            --     settings = {
            --         java = {
            --             configuration = {
            --                 runtimes = {
            --                     {
            --                         name = "JavaSE-21",
            --                         path = "/opt/homebrew/opt/openjdk@21",
            --                         default = true,
            --                     }
            --                 }
            --             }
            --         }
            --     }
            --
            -- })
            require('lspconfig').gopls.setup({
                settings = {
                    basedpyright = {
                        typeCheckingMode = "all",
                        -- analysis = {
                        --     diagnosticSeverityOverrides = {
                        --         reportMissingParameterType = false,
                        --         reportUnknownParameterType = false,
                        --     },
                        -- },
                    },
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
