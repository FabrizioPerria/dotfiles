local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("config.keymaps")
require("config.options")
require("config.autocmds")

vim.lsp.enable({
    "ansiblels",
    "basedpyright",
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "docker_compose_language_service",
    "dockerls",
    "dotls",
    "eslint",
    "gopls",
    "jsonls",
    "lua_ls",
    "marksman",
    "tailwindcss",
    "ts_ls",
    "yamlls",
})
require("lazy").setup("plugins")
