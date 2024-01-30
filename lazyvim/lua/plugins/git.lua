return {
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },
  { "tpope/vim-fugitive" },
  { "junegunn/gv.vim" },
  {
    "f-person/git-blame.nvim",
    config = function()
      vim.g.gitblame_enabled = false
      require("gitblame").setup({
        enabled = false,
        message_template = "[<sha>] <summary> • <author> • <date>",
      })
    end,
  },
  {
    "sindrets/diffview.nvim",
    config = function()
      require("diffview").setup({
        view = {
          merge_tool = {
            layout = "diff3_mixed",
            disable_diagnostics = false,
          },
        },
      })
    end,
  },
}
