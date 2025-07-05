return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        build = "make tiktoken",
        dependencies = {
            { "zbirenbaum/copilot.lua" },
            { "nvim-lua/plenary.nvim" },
        },
        opts = {
            mode = "float",
            show_help = "yes",
            question_header = "## User ",
            answer_header = "## Copilot ",
            error_header = "## Error ",
            separator = "───", -- Separator to use in chat
            auto_follow_cursor = false, -- Don't follow the cursor after getting response

            -- model = "gpt-4o", -- GPT model to use, see ':CopilotChatModels' for available models
            model = "claude-3.5-sonnet",
            temperature = 0.1, -- GPT temperature

            show_folds = true, -- Shows folds for sections in chat
            auto_insert_mode = false, -- Automatically enter insert mode when opening window and on new prompt
            insert_at_end = false, -- Move cursor to end of buffer when inserting text
            clear_chat_on_new_prompt = false, -- Clears chat on every new prompt
            highlight_selection = true, -- Highlight selection in the source buffer when in the chat window

            context = nil, -- Default context to use, 'buffers', 'buffer' or none (can be specified manually in prompt via @).
            history_path = vim.fn.stdpath("data") .. "/copilotchat_history", -- Default path to stored history
            callback = nil, -- Callback to use when ask response is received

            window = {
                layout = "float", -- 'vertical', 'horizontal', 'float', 'replace'
                width = 0.5, -- fractional width of parent, or absolute width in columns when > 1
                height = 0.5, -- fractional height of parent, or absolute height in rows when > 1
                -- Options below only apply to floating windows
                relative = "editor", -- 'editor', 'win', 'cursor', 'mouse'
                border = "single", -- 'none', single', 'double', 'rounded', 'solid', 'shadow'
                row = nil, -- row position of the window, default is centered
                col = nil, -- column position of the window, default is centered
                title = "Copilot Chat", -- title of chat window
                footer = nil, -- footer of chat window
                zindex = 1, -- determines if window is on top or below other floating windows
            },

            -- default mappings
            mappings = {
                complete = {
                    detail = "Use @<Tab> or /<Tab> for options.",
                    insert = "<Tab>",
                },
                close = {
                    normal = "q",
                    insert = "<C-c>",
                },
                reset = {
                    normal = "<C-x>",
                    insert = "<C-x>",
                },
                submit_prompt = {
                    normal = "<CR>",
                    insert = "<C-CR>",
                },
                accept_diff = {
                    normal = "<C-y>",
                    insert = "<C-y>",
                },
                yank_diff = {
                    normal = "gy",
                    register = '"',
                },
                show_diff = {
                    normal = "gd",
                },
                show_info = {
                    normal = "gp",
                },
                show_context = {
                    normal = "gs",
                },
            },
        },

        build = function()
            vim.cmd("make tiktoken")
            vim.defer_fn(function()
                vim.cmd("UpdateRemotePlugins")
                vim.notify("CopilotChat - Updated remote plugins. Please restart Neovim.")
            end, 3000)
        end,
        lazy = true,
        keys = {
            { "<leader>c", ":CopilotChatToggle<CR>", desc = "CopilotChat Toggle prompt" },
            { "<leader>cc", ":CopilotChat ", desc = "CopilotChat Inline" },
            { "<leader>cs", ":CopilotChatSave ", desc = "CopilotChat Save" },
            { "<leader>cl", ":CopilotChatLoad ", desc = "CopilotChat Load" },
        },
    },
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        keys = {
            { "<leader>shutup", ":Copilot disable<CR>", desc = "Copilot Disable" },
            { "<leader>help", ":Copilot enable<CR>", desc = "Copilot Enable" },
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
                        accept_word = "<M-W>",
                        accept_line = "<M-L>",
                        next = "<M-]>",
                        prev = "<M-[>",
                        dismiss = "<C-]>",
                    },
                },
            })
        end,
    },
}
