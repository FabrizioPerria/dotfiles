return {
  "zbirenbaum/copilot.lua",
  opts = {
    panel = { enabled = false },
    suggestion = {
      enabled = true,
      auto_trigger = true,
      debounce = 75,
      keymap = {
        accept = "<M-a>",
        accept_word = "<M-w>",
        accept_line = "<M-l>",
        next = "<M-]>",
        prev = "<M-[>",
        dismiss = "<C-]>",
      },
    },
  },
  config = function(_, opts)
    require("copilot").setup(opts)
  end,
}

