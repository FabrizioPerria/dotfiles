return {
  "echasnovski/mini.surround",
  opts = {
    mappings = {
      add = "ys", -- Add surrounding in Normal and Visual modes
      delete = "ds", -- Delete surrounding
      find = "fs", -- Find surrounding (to the right)
      find_left = "fS", -- Find surrounding (to the left)
      highlight = "hs", -- Highlight surrounding
      replace = "cs", -- Replace surrounding
    },
  },
}
-- return {
--   "kylechui/nvim-surround",
--   version = "*", -- Use for stability; omit to use `main` branch for the latest features
--   event = "VeryLazy",
--   config = function()
--     require("nvim-surround").setup({})
--   end,
-- }
