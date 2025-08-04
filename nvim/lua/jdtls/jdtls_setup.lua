M = {}

function M.setup()
    local function get_launcher()
        local jdtls_path = vim.fn.expand("$MASON/packages/jdtls")
        local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
        return launcher
    end
    local function get_os_config()
        local jdtls_path = vim.fn.expand("$MASON/packages/jdtls")
        local uname = vim.loop.os_uname().sysname
        local SYSTEM = "linux" -- default

        if uname == "Darwin" then
            SYSTEM = "mac"
        elseif uname == "Linux" then
            SYSTEM = "linux"
        end
        SYSTEM = "mac" -- force macOS for now
        local config = jdtls_path .. "/config_" .. SYSTEM
        return config
    end
    local function get_agent()
        local jdtls_path = vim.fn.expand("$MASON/packages/jdtls")
        local lombok = jdtls_path .. "/lombok.jar"
        return lombok
    end

    local function get_workspace()
        local home = os.getenv("HOME")
        local workspace_path = home .. "/.cache/nvim/jdtls/workspace/"
        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ":p:h:t")
        local workspace_dir = workspace_path .. project_name
        return workspace_dir
    end

    local function getBundles()
        local java_debug_path = vim.fn.expand("$MASON/packages/java-debug-adapter")

        local bundles = {
            vim.fn.glob(java_debug_path .. "/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
        }

        local java_test_path = vim.fn.expand("$MASON/packages/java-test")
        vim.list_extend(bundles, vim.split(vim.fn.glob(java_test_path .. "/extension/server/*.jar", 1), "\n"))

        return bundles
    end

    local function java_keymaps()
        vim.cmd(
            "command! -buffer -nargs=? -complete=custom,v:lua.require'jdtls'._complete_compile JdtCompile lua require('jdtls').compile(<f-args>)"
        )
        vim.cmd("command! -buffer JdtUpdateConfig lua require('jdtls').update_project_config()")
        vim.cmd("command! -buffer JdtBytecode lua require('jdtls').javap()")
        vim.cmd("command! -buffer JdtJshell lua require('jdtls').jshell()")

        vim.keymap.set(
            "n",
            "<leader>Jo",
            "<Cmd> lua require('jdtls').organize_imports()<CR>",
            { desc = "[J]ava [O]rganize Imports" }
        )
        vim.keymap.set(
            "n",
            "<leader>Jv",
            "<Cmd> lua require('jdtls').extract_variable()<CR>",
            { desc = "[J]ava Extract [V]ariable" }
        )
        vim.keymap.set(
            "v",
            "<leader>Jv",
            "<Esc><Cmd> lua require('jdtls').extract_variable(true)<CR>",
            { desc = "[J]ava Extract [V]ariable" }
        )
        vim.keymap.set(
            "n",
            "<leader>JC",
            "<Cmd> lua require('jdtls').extract_constant()<CR>",
            { desc = "[J]ava Extract [C]onstant" }
        )
        vim.keymap.set(
            "v",
            "<leader>JC",
            "<Esc><Cmd> lua require('jdtls').extract_constant(true)<CR>",
            { desc = "[J]ava Extract [C]onstant" }
        )
        vim.keymap.set(
            "n",
            "<leader>Jt",
            "<Cmd> lua require('jdtls').test_nearest_method()<CR>",
            { desc = "[J]ava [T]est Method" }
        )
        vim.keymap.set(
            "v",
            "<leader>Jt",
            "<Esc><Cmd> lua require('jdtls').test_nearest_method(true)<CR>",
            { desc = "[J]ava [T]est Method" }
        )
        vim.keymap.set(
            "n",
            "<leader>JT",
            "<Cmd> lua require('jdtls').test_class()<CR>",
            { desc = "[J]ava [T]est Class" }
        )
        vim.keymap.set("n", "<leader>Ju", "<Cmd> JdtUpdateConfig<CR>", { desc = "[J]ava [U]pdate Config" })
    end

    local on_attach = function(_, bufnr)
        java_keymaps()

        require("jdtls.dap").setup_dap({})
        -- require("jdtls.dap").setup_dap({ hotcodereplace = "auto" })

        require("jdtls.dap").setup_dap_main_class_configs()
        require("jdtls.setup").add_commands()
        -- vim.lsp.codelens.refresh()

        vim.api.nvim_create_autocmd("BufWritePost", {
            pattern = { "*.java", "pom.xml", "build.gradle", "settings.gradle" },
            callback = function()
                -- local _, _ = pcall(vim.lsp.codelens.refresh)
                require("jdtls").compile("incremental")
            end,
        })
    end

    local extendedClientCapabilities = require("jdtls").extendedClientCapabilities
    extendedClientCapabilities.resolveAdditionalTextEditsSupport = true

    local function getCapabilities()
        local capabilities = {
            workspace = {
                configuration = true,
            },
            textDocument = {
                completion = {
                    snippetSupport = false,
                },
            },
        }

        local lsp_capabilities = require("cmp_nvim_lsp").default_capabilities()

        for k, v in pairs(lsp_capabilities) do
            capabilities[k] = v
        end
        return capabilities
    end

    local jdtls_config = {
        cmd = {
            "java",
            "-Declipse.application=org.eclipse.jdt.ls.core.id1",
            "-Dosgi.bundles.defaultStartLevel=4",
            "-Declipse.product=org.eclipse.jdt.ls.core.product",
            "-Dlog.protocol=true",
            "-Dlog.level=ALL",
            "-Xmx1g",
            "--add-modules=ALL-SYSTEM",
            "--add-opens",
            "java.base/java.util=ALL-UNNAMED",
            "--add-opens",
            "java.base/java.lang=ALL-UNNAMED",
            "-javaagent:" .. get_agent(),
            "-jar",
            get_launcher(),
            "-configuration",
            get_os_config(),
            "-data",
            get_workspace(),
        },
        root_dir = require("jdtls").setup.find_root({
            ".git",
            "mvnw",
            "gradlew",
            "pom.xml",
            "settings.gradle",
            "build.gradle",
        }),
        settings = {
            java = {
                format = {
                    enabled = false,
                    settings = {
                        url = vim.fn.stdpath("config") .. "/styles/intellij-java-google-style.xml",
                        profile = "GoogleStyle",
                    },
                },
                eclipse = {
                    downloadSource = true,
                },
                maven = {
                    downloadSources = true,
                },
                signatureHelp = {
                    enabled = true,
                },
                contentProvider = {
                    preferred = "fernflower",
                },
                saveActions = {
                    organizeImports = true,
                },
                completion = {
                    favoriteStaticMembers = {
                        "org.hamcrest.MatcherAssert.assertThat",
                        "org.hamcrest.Matchers.*",
                        "org.hamcrest.CoreMatchers.*",
                        "org.junit.jupiter.api.Assertions.*",
                        "java.util.Objects.requireNonNull",
                        "java.util.Objects.requireNonNullElse",
                        "org.mockito.Mockito.*",
                    },
                    filteredTypes = {
                        "com.sun.*",
                        "io.micrometer.shaded.*",
                        "java.awt.*",
                        "jdk.*",
                        "sun.*",
                    },
                    importOrder = {
                        "java",
                        "jakarta",
                        "javax",
                        "com",
                        "org",
                    },
                },
                sources = {
                    organizeImports = {
                        starThreshold = 9999,
                        staticThreshold = 9999,
                    },
                },
                codeGeneration = {
                    toString = {
                        template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}",
                    },
                    hashCodeEquals = {
                        useJava7Objects = true,
                    },
                    useBlocks = true,
                },
                configuration = {
                    updateBuildConfiguration = "interactive",
                },
                referencesCodeLens = {
                    enabled = false,
                },
                inlayHints = {
                    parameterNames = {
                        enabled = "all",
                    },
                },
            },
        },
        capabilities = getCapabilities(),
        init_options = {
            bundles = getBundles(),
            extendedClientCapabilities = extendedClientCapabilities,
        },
        on_attach = on_attach,
        -- filetypes = { "java" },
        -- root_markers = { ".git", "mvnw", "gradlew", "pom.xml", "settings.gradle" },
        -- single_file_support = false,
    }
    require("jdtls").start_or_attach(jdtls_config)
end

return M
