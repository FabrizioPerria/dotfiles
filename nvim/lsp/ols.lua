local config = {
  filetypes = { 'odin' },
  root_markers = { 'ols.json', '.git' },
}
 
vim.lsp.config('ols', config)
return config

