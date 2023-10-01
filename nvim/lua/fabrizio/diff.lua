-- local M = {}
-- local api = vim.api
-- local override = 'DiffAddAsDelete'

-- -- This overrides DiffAdd in fugitive buffers, turning them into something that
-- -- looks like DiffDelete (while allowing it to be highlighted differently).
-- --
-- -- This hack ensures that deletions in the previous version of a diff show up
-- -- as actual deletions, not additions (relative to the current version).
-- function M.fix_highlight()
--   local nr = api.nvim_win_get_buf(0)
--   local name = api.nvim_buf_get_name(nr)
--   local winhl = vim.wo.winhl

--   if not vim.wo.diff or winhl:match(override) then
--     return
--   end

--   if winhl == '' then
--     vim.wo.winhl = 'DiffAdd:' .. override
--   else
--     vim.wo.winhl = winhl .. ',DiffAdd:' .. override
--   end
-- end

-- return M
