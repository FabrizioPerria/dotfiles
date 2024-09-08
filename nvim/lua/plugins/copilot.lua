return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        -- Will be merged to main branch soon
        -- branch = "canary",
        version = "v2.10.1",
        opts = {
            mode = "split",
            show_help = "yes",
            question_header = "## User ",
            answer_header = "## Copilot ",
            error_header = "## Error ",
            auto_follow_cursor = false, -- Don't follow the cursor after getting response
            -- show_help = false,              -- Show help in virtual text, set to true if that's 1st time using Copilot Chat
            mappings = {
                -- Use tab for completion
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options.",
                    insert = "<Tab>",
                },
                -- Close the chat
                close = {
                    normal = "q",
                    insert = "<C-c>",
                },
                -- Reset the chat buffer
                reset = {
                    normal = "<C-x>",
                    insert = "<C-x>",
                },
                -- Submit the prompt to Copilot
                submit_prompt = {
                    normal = "<CR>",
                    insert = "<C-CR>",
                },
                -- Accept the diff
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>",
                },
                -- Yank the diff in the response to register
                yank_diff = {
                    normal = "gmy",
                },
                -- Show the diff
                show_diff = {
                    normal = "gmd",
                },
                -- Show the prompt
                show_system_prompt = {
                    normal = "gmp",
                },
                -- Show the user selection
                show_user_selection = {
                    normal = "gms",
                },
            },
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
                filetypes = {
                    yaml = true,
                    yml = true,
                    json = true,
                    markdown = true,
                    help = true,
                },
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
