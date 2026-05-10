local config = {
    cmd = { "yaml-language-server", "--stdio" },
    capabilities = (function()
        local caps = vim.lsp.protocol.make_client_capabilities()
        caps.textDocument.completion.completionItem.snippetSupport = true
        return caps
    end)(),
    filetypes = { "yaml", "yml" },
    root_markers = { ".git/", "yamllint.yaml", "yamlconfig.yaml" },
    settings = {
        yaml = {
            validate = true,
            completion = true,
            hover = true,
            schemaStore = { enable = true, url = "https://www.schemastore.org/api/json/catalog.json" },
            schemas = {
                ["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] = {
                    "docker-compose*.yml",
                    "docker-compose*.yaml",
                },
                ["https://json.schemastore.org/github-workflow.json"] = ".github/workflows/*.yml",
                ["https://json.schemastore.org/github-action.json"] = ".github/actions/*/action.yml",
                ["https://json.schemastore.org/ansible-playbook.json"] = "*playbook*.yml",
                ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml",
                ["https://raw.githubusercontent.com/kubernetes/kubernetes/master/api/openapi-spec/swagger.json"] = {
                    "*.k8s.yaml",
                    "*.k8s.yml",
                },
            },
        },
        redhat = {
            telemetry = { enabled = false },
        },
    },
}
vim.lsp.config("yamlls", config)
return config
