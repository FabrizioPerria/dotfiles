local config = {
      cmd = { 'neocmakelsp', 'stdio' },
      filetypes = { 'cmake' },
      root_markers = { '.neocmake.toml', '.git', 'build', 'cmake' },
      capabilities = vim.lsp.protocol.make_client_capabilities(),
}
vim.lsp.config("cmake", config)
return config
