-- File: lua/my/live_grep_tracker.lua
local M = {}

local last_query = ""

function M.livegrep()
    local lga = require("telescope").extensions.live_grep_args
    local actions = require("telescope.actions")
    local action_state = require("telescope.actions.state")
    local action_set = require("telescope.actions.set")

    lga.live_grep_args({
        auto_quoting = true,
        -- additional_args = function()
        --     return {
        --         "--glob",
        --         "!node_modules/*",
        --         "--glob",
        --         "!.git/*",
        --         "--glob",
        --         "!.venv/*",
        --     }
        -- end,
        -- No real default_text support, so we simulate it after open
        attach_mappings = function(prompt_bufnr, map)
            local picker = action_state.get_current_picker(prompt_bufnr)
            -- Save input on <CR>
            map({ "i", "n" }, "<CR>", function()
                local selection = action_state.get_selected_entry()
                if selection then
                    actions.select_default(prompt_bufnr)
                    last_query = action_state.get_current_line()
                end
            end)
            -- Save input on escape
            map({ "i", "n" }, "<Esc>", function()
                actions.close(prompt_bufnr)
                last_query = action_state.get_current_line()
            end)

            map({ "i", "n" }, "<C-x>", function()
                last_query = ""
                picker:set_prompt("")
            end)

            -- Simulate pre-fill after the picker is ready
            vim.defer_fn(function()
                -- simulate typing the last query into the prompt
                -- if last_query ~= "" then
                picker:set_prompt(last_query)
                -- vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(last_query, true, false, true), "t", false)
                -- end
            end, 10)

            return true
        end,
    })
end

return M
