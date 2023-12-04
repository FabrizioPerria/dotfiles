local function DiffViewToggle()
  if next(require("diffview.lib").views) == nil then
    vim.cmd("DiffviewOpen")
  else
    vim.cmd("DiffviewClose")
  end
end

return {
  {
    "tpope/vim-fugitive",
    vscode = false,
    keys = {
      {
        "<leader>gco",
        ':Git commit -S -m ""<Left>',
        " ",
        mode = { "n" },
        silent = false,
      },
      {
        "<leader>gg",
        ":Git pull --rebase",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>gp",
        ":Git push -u origin ",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>gm",
        ":Git merge ",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>gL",
        "<cmd>vert Git log --show-signature | vertical resize 100<cr>",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>gch",
        ":Git checkout ",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>gsa",
        "<cmd>Git stash<cr>",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>gsp",
        "<cmd>Git stash pop<cr>",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>ga",
        "<cmd>Gwrite<cr>",
        " ",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>g-",
        "<cmd>Gread<cr>",
        " ",
        silent = false,
        mode = { "n" },
      },
    },
  },

  {
    "lewis6991/gitsigns.nvim",
    vscode = false,
    opts = {
      signs = {
        add = { hl = "GitSignsAdd", text = "▌", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
        change = {
          hl = "GitSignsChange",
          text = "▌",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        delete = { hl = "GitSignsDelete", text = "_", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
        topdelete = {
          hl = "GitSignsDelete",
          text = "-",
          numhl = "GitSignsDeleteNr",
          linehl = "GitSignsDeleteLn",
        },
        changedelete = {
          hl = "GitSignsChange",
          text = "~",
          numhl = "GitSignsChangeNr",
          linehl = "GitSignsChangeLn",
        },
        untracked = { hl = "GitSignsAdd", text = "▌", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      },
    },
    config = function(_, opts)
      require("gitsigns").setup(opts)
    end,
  },
  {
    "junegunn/gv.vim",
    vscode = false,
    cmd = "GV",
    keys = {
      { "<leader>gt", "<cmd>GV<cr>", " ", silent = false, mode = { "n" } },
    },
  },
  {
    "f-person/git-blame.nvim",
    vscode = false,
    keys = {
      { "<leader>gb", "<cmd>GitBlameToggle<cr>", " ", silent = false, mode = { "n" } },
    },
    opts = {
      enabled = false,
      message_template = "[<sha>] <summary> • <author> • <date>",
    },
    config = function(_, opts)
      require("git-blame").setup(opts)
      vim.g.gitblame_enabled = fals
    end,
  },
  {
    "sindrets/diffview.nvim",
    vscode = false,
    cmd = "DiffviewOpen",
    keys = {
      { "<leader>gd", DiffViewToggle, " ", mode = { "n" } },
      { "<leader>g<Left>", "<cmd>lua require('diffview.actions').diffget('ours')<cr>", " ", mode = { "n", "x" } },
      { "<leader>g<Right>", "<cmd>lua require('diffview.actions').diffget('theirs')<cr>", " ", mode = { "n", "x" } },
      { "<leader>g<Down>", "<cmd>lua require('diffview.actions').diffput('local')<cr>", " ", mode = { "n", "x" } },
      { "<leader>g<Up>", "<C-j>u", " ", mode = { "n", "x" } },
    },
    opts = {
      view = {
        merge_tool = {
          layout = "diff3_mixed",
          disable_diagnostics = false,
        },
      },
    },
    config = function(_, opts)
      require("diffview").setup(opts)
    end,
  },
}
