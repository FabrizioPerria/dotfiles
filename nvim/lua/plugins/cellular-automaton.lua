if not vim.g.vscode then
  local slide = {
    fps = 50,
    name = "slide",
    update = function(grid)
      for i = 1, #grid do
        local prev = grid[i][#grid[i]]
        for j = 1, #grid[i] do
          grid[i][j], prev = prev, grid[i][j]
        end
      end
      return true
    end,
  }

  return {
    "eandrju/cellular-automaton.nvim",
    event = "VeryLazy",
    keys = {
      {
        "<leader>camir",
        "<cmd>CellularAutomaton make_it_rain<cr>",
        desc = "Make it rain",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>cagol",
        "<cmd>CellularAutomaton game_of_life<cr>",
        desc = "Game of life",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>cascr",
        "<cmd>CellularAutomaton scramble<cr>",
        desc = "Scramble",
        silent = false,
        mode = { "n" },
      },
      {
        "<leader>casli",
        "<cmd>CellularAutomaton slide<cr>",
        desc = "Slide",
        silent = false,
        mode = { "n" },
      },
    },
  }
end
