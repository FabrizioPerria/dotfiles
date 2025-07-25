local config = {
    cmd = { "ansible-language-server", "--stdio" },
    capabilities = require("cmp_nvim_lsp").default_capabilities(),
    filetypes = {
        "yaml",
        "yml",
    },
    root_markers = { "playbook.yml", "playbook.yaml", "ansible.cfg", ".ansible-lint" },
    settings = {
        ansible = {
            ansible = {
                path = "ansible",
            },
            executionEnvironment = {
                enabled = false,
            },
            python = {
                interpreterPath = "python3.12",
            },
            validation = {
                enabled = true,
                lint = {
                    enabled = false,
                    path = "ansible-lint",
                },
            },
        },
    },
}
vim.lsp.config("ansiblels", config)
return config
