return {
  "ThePrimeagen/harpoon",
  keys = {
    { "<leader>h1", "<cmd> lua require('harpoon.ui').nav_file(1)<cr>", mode = { "n" } },
    { "<leader>h2", "<cmd> lua require('harpoon.ui').nav_file(2)<cr>", mode = { "n" } },
    { "<leader>h3", "<cmd> lua require('harpoon.ui').nav_file(3)<cr>", mode = { "n" } },
    { "<leader>h4", "<cmd> lua require('harpoon.ui').nav_file(4)<cr>", mode = { "n" } },
    { "<leader>h5", "<cmd> lua require('harpoon.ui').nav_file(5)<cr>", mode = { "n" } },
    { "<leader>h6", "<cmd> lua require('harpoon.ui').nav_file(6)<cr>", mode = { "n" } },
    { "<leader>h7", "<cmd> lua require('harpoon.ui').nav_file(7)<cr>", mode = { "n" } },
    { "<leader>h8", "<cmd> lua require('harpoon.ui').nav_file(8)<cr>", mode = { "n" } },
    { "<leader>h9", "<cmd> lua require('harpoon.ui').nav_file(9)<cr>", mode = { "n" } },
    { "<leader>ha", "<cmd> lua require('harpoon.mark').add_file<cr>", mode = { "n" } },
    { "<leader>hs", "<cmd> lua require('harpoon.ui').toggle_quick_menu<cr>", mode = { "n" } },
    { "<leader>hp", "<cmd> lua require('harpoon.ui').nav_prev<cr>", mode = { "n" } },
    { "<leader>hn", "<cmd> lua require('harpoon.ui').nav_next<cr>", mode = { "n" } },
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
}
