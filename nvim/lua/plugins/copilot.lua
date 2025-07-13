local current_file = ""

local function show_answer(answer)
    local buf = vim.api.nvim_create_buf(false, true) -- create new (scratch) buffer
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, vim.split(answer, "\n"))
    vim.api.nvim_buf_set_option(buf, "modifiable", false)

    local width = 0
    for _, line in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
        if #line > width then
            width = #line
        end
    end
    width = math.min(width, 120)
    local height = 10
    local opts = {
        style = "minimal",
        border = "single",
        title = "Copilot Chat Quick Answer",
        relative = "editor",
        width = width,
        height = height,
        row = (vim.o.lines - height) / 2,
        col = (vim.o.columns - width) / 2,
    }

    vim.api.nvim_open_win(buf, true, opts)
    vim.api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

local function chat_inline()
    local input = vim.fn.input("CopilotChat: ")
    if input and input ~= "" then
        require("CopilotChat").ask(input, {
            headless = true,
            callback = function(response)
                if response then
                    show_answer(response)
                else
                    show_answer("No response received.")
                end
            end,
        })
    else
        show_answer("No input provided.")
    end
end

local function find_copilot_chats()
    local telescope = require("telescope.builtin")
    local chats_dir = vim.fn.stdpath("data") .. "/copilotchat_history"

    telescope.find_files({
        prompt_title = "Copilot Chats",
        cwd = chats_dir,
        hidden = false,
        find_command = { "find", ".", "-type", "f", "-name", "*.json", "-exec", "ls", "-t", "{}", "+" },
        previewer = require("telescope.previewers").new_buffer_previewer({
            define_preview = function(self, entry)
                vim.api.nvim_buf_set_option(self.state.bufnr, "filetype", "json")
                vim.api.nvim_buf_set_option(self.state.bufnr, "wrap", true)
                vim.wo.wrap = true
                local content = vim.fn.readfile(chats_dir .. "/" .. entry.value)
                local json_str = table.concat(content, "\n")
                local formatted = vim.fn.system({ "jq", "." }, json_str)
                formatted = formatted:gsub("%s+$", "")
                vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(formatted, "\n"))
            end,
        }),
        attach_mappings = function(prompt_bufnr, map)
            map("i", "<CR>", function()
                local selection = require("telescope.actions.state").get_selected_entry()
                require("telescope.actions").close(prompt_bufnr)
                local filename = vim.fn.fnamemodify(selection.value, ":t:r")
                vim.cmd("CopilotChatLoad " .. filename)
                vim.cmd("CopilotChatToggle")
                vim.fn.system("rm " .. vim.fn.stdpath("data") .. "/copilotchat_history/" .. selection.value)
                current_file = filename
                print("Loaded CopilotChat session: " .. filename)
            end)
            map("i", "<A-d>", function()
                local action_state = require("telescope.actions.state")
                local selection = action_state.get_selected_entry()
                local file_path = chats_dir .. "/" .. selection.value
                vim.fn.system("rm " .. file_path)
                require("telescope.actions").close(prompt_bufnr)
            end)
            return true
        end,
    })
end

local function open_new_copilot_chat()
    vim.cmd("CopilotChatReset") -- Reset any existing chat session
    current_file = "" -- Reset current file name
    vim.cmd("CopilotChatToggle") -- Open the CopilotChat window
end

-- Auto-save CopilotChat sessions when chat buffer is closed
vim.api.nvim_create_autocmd("BufWinLeave", {
    callback = function(args)
        local buf = args.buf
        local ft = vim.bo[buf].filetype

        if ft == "copilot-chat" then
            local bufContent = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
            bufContent = table.concat(bufContent, "\n")

            -- Create a new buffer for the chat content
            local chat_buf = vim.api.nvim_create_buf(false, true)
            vim.api.nvim_buf_set_lines(chat_buf, 0, -1, false, vim.split(bufContent, "\n"))

            if current_file == "" then
                current_file = "" .. os.date("%Y-%m-%d__%H-%M-%S")
            end
            vim.cmd("silent! CopilotChatSave " .. current_file)
            -- if current_file ~= "" then
            --     vim.cmd("CopilotChatSave " .. current_file)
            --     print("[same file] Saved CopilotChat session as: " .. current_file)
            -- else
            --     -- Ask for summary and wait for response
            --     require("CopilotChat").ask(
            --         "Summarize in 8 words or less(only say those exact words, i'm using it as file name). If the input is empty or you have nothing to summarize, just say no:"
            --             .. bufContent({
            --                 headless = true,
            --                 buffer = chat_buf,
            --                 callback = function(response)
            --                     local topic = response:gsub("[^%w%s]", ""):gsub("%s+", "_")
            --                     if topic == "" or topic:lower() == "no" then
            --                         print("No topic provided, not saving session.")
            --                         return
            --                     end
            --                     local filename = os.date("%Y-%m-%d___") .. topic
            --                     vim.schedule(function()
            --                         vim.cmd("CopilotChatSave " .. filename)
            --                         print("[new file] Saved CopilotChat session as: " .. filename)
            --                         current_file = filename
            --                     end)
            --                 end,
            --             })
            --     )
            -- end
        end
    end,
})

return {
    {
        "CopilotC-Nvim/CopilotChat.nvim",
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

            model = "gpt-4.1", -- GPT model to use, see ':CopilotChatModels' for available models
            -- model = "claude-3.5-sonnet",
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
                width = 0.6, -- fractional width of parent, or absolute width in columns when > 1
                height = 0.6, -- fractional height of parent, or absolute height in rows when > 1
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
            { "<leader>cc", open_new_copilot_chat, desc = "CopilotChat New Chat" },
            { "<leader>fc", find_copilot_chats, desc = "Find Copilot Chats" },
            { "<leader>ci", chat_inline, desc = "CopilotChat Inline" },
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
