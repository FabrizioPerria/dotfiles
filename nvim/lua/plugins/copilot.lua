return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        -- Will be merged to main branch soon
        branch = "canary",
        opts = {
            mode = "split",
            show_help = "yes",
        },
        build = function()
            vim.defer_fn(function()
                vim.cmd("UpdateRemotePlugins")
                vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
            end, 3000)
        end,
        lazy = true,
        keys = {
            { "<leader>c",  ":CopilotChatToggle<CR>", desc = "CopilotChat Toggle prompt" },
            { "<leader>cc", ":CopilotChat ",          desc = "CopilotChat Inline" },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        keys = {
            { "<leader>shutup", ":Copilot disable<CR>", desc = "Copilot Disable" },
            { "<leader>help",   ":Copilot enable<CR>",  desc = "Copilot Enable" },
        },
        config = function()
            require("copilot").setup({
                panel = { enabled = false },
                suggestion = {
                    enabled = true,
                    auto_trigger = true,
                    debounce = 75,
                    keymap = {
                        accept = "<Tab>",
                        accept_word = "<M-w>",
                        accept_line = "<M-l>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
            })
        end,
    },
}
