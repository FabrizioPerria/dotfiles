return {
  "ThePrimeagen/harpoon",
  vscode = false,
  keys = {
    { "<leader>h1", "<cmd> lua require('harpoon'):list():select(1)<cr>", mode = { "n" } },
    { "<leader>h2", "<cmd> lua require('harpoon'):list():select(2)<cr>", mode = { "n" } },
    { "<leader>h3", "<cmd> lua require('harpoon'):list():select(3)<cr>", mode = { "n" } },
    { "<leader>h4", "<cmd> lua require('harpoon'):list():select(4)<cr>", mode = { "n" } },
    { "<leader>h5", "<cmd> lua require('harpoon'):list():select(5)<cr>", mode = { "n" } },
    { "<leader>h6", "<cmd> lua require('harpoon'):list():select(6)<cr>", mode = { "n" } },
    { "<leader>h7", "<cmd> lua require('harpoon'):list():select(7)<cr>", mode = { "n" } },
    { "<leader>h8", "<cmd> lua require('harpoon'):list():select(8)<cr>", mode = { "n" } },
    { "<leader>h9", "<cmd> lua require('harpoon'):list():select(9)<cr>", mode = { "n" } },
    { "<leader>ha", "<cmd> lua require('harpoon'):list():append()<cr>", mode = { "n" } },
    {
      "<leader>hs",
      "<cmd> lua require('harpoon').ui:toggle_quick_menu(require('harpoon'):list())<cr>",
      mode = { "n" },
    },
  },
  opts = {
    global_settings = {
      save_on_toggle = false,
      save_on_change = true,
      enter_on_sendcmd = true,
      tmux_autoclose_windows = false,
      excluded_filetypes = { "harpoon", "alpha", "dashboard", "gitcommit" },
      mark_branch = false,
    },
  },
  config = function()
    require("harpoon"):setup()
  end,
}
