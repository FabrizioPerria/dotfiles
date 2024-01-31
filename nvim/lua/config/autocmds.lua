-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
if not vim.g.vscode then
  local refresh = vim.api.nvim_create_augroup("refresh", { clear = true })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.lua" },
    group = refresh,
    command = 'if expand("%:t") == "packer.lua" | nnoremap <buffer> <leader><leader> :w<CR>:so<CR>:PackerSync<CR> | else | nnoremap <buffer> <leader><leader> :w<CR>:so<CR> | endif',
  })

  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "CMakeLists.txt" },
    group = refresh,
    -- command = 'nnoremap <buffer> <leader><leader> :w<CR>:vsplit<bar>term ./doit.sh<CR>'
    command = "nnoremap <buffer> <leader><leader> :wa<CR>:FloatermNew --autoclose=0 ./build.sh<CR>",
  })
  vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*.cs", "*.cproj", "*.sln" },
    group = refresh,
    command = "nnoremap <buffer> <leader><leader> :w<CR>:term dotnet build<CR>",
  })

  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      vim.lsp.buf.format()
    end,
  })

  vim.api.nvim_create_autocmd("TermOpen", {
    callback = function()
      vim.cmd("norm G")
      vim.cmd([[nnoremap <buffer> <Esc> :bd!<CR>]])
    end,
  })
else
  local vscode = require("vscode-neovim")
  vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
      vscode.call("editor.action.formatDocument")
    end,
  })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.c", "*.cpp", "*.h", "*.hpp", "CMakeLists.txt" },
    command = 'nnoremap <buffer> <leader><leader> <Cmd>wa<CR><Cmd>call VSCodeCall("cmake.build")<CR>',
  })
  vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
    pattern = { "*.cs", "*.cproj", "*.sln" },
    command = 'nnoremap <buffer> <leader><leader> <Cmd>wa<CR><Cmd>call VSCodeCall("msbuild-tools.build")<CR>',
  })
end
