local qf_ns = vim.api.nvim_create_namespace('qf_checkbox')

local function paint_qf(buf)
  vim.api.nvim_buf_clear_namespace(buf, qf_ns, 0, -1)
  local items = vim.fn.getqflist({ id = 0, items = 1 }).items
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  for i, item in ipairs(items) do
    local done = item.user_data and item.user_data.checked
    local hl = done and 'DiffAdd' or 'DiffDelete'   -- keep whatever groups you're using
      vim.api.nvim_set_hl(0, 'QuickFixLine', {})
    vim.api.nvim_buf_set_extmark(buf, qf_ns, i - 1, 0, {
      end_col = #(lines[i] or ''),
      hl_group = hl,
      hl_eol = true,
      hl_mode = 'combine',
      virt_text = { { done and '✓ ' or '✗ ', hl } },
      virt_text_pos = 'inline',
    })
  end
end

local function toggle_qf_item()
  local win = vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_get_current_buf()
  local pos = vim.api.nvim_win_get_cursor(win)
  local idx = pos[1]
  local list = vim.fn.getqflist({ id = 0, items = 1 })
  local item = list.items[idx]
  if not item then return end
  local ud = type(item.user_data) == 'table' and item.user_data or {}
  ud.checked = not ud.checked
  item.user_data = ud
  vim.fn.setqflist({}, 'r', { id = list.id, items = list.items, idx = idx })
  vim.api.nvim_win_set_cursor(win, pos)
  paint_qf(buf)
end

local function close_qf()
  vim.cmd(vim.fn.win_gettype() == 'loclist' and 'lclose' or 'cclose')
end

local function reset_qf_checks()
  local list = vim.fn.getqflist({ id = 0, items = 1 })
  for _, item in ipairs(list.items) do
    if type(item.user_data) == 'table' then item.user_data.checked = nil end
  end
  vim.fn.setqflist({}, 'r', { id = list.id, items = list.items })
  paint_qf(buf)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function(ev)
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'x', toggle_qf_item, opts)
    vim.keymap.set('n', 'R', reset_qf_checks, opts)
    vim.keymap.set('n', 'q', close_qf, opts)
    vim.keymap.set('n', '<Esc>', close_qf, opts)
  end,
})

vim.api.nvim_create_autocmd('BufWinEnter', {
  callback = function(ev)
    if vim.bo[ev.buf].filetype == 'qf' then
      paint_qf(ev.buf)
    end
  end,
})
