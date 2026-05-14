local config = {
  filetypes = { 'zig' },
  root_markers = { 'build.zig' },
  settings = {
    zls = {
    }
  },
}

vim.lsp.config('zls', config)
return config
