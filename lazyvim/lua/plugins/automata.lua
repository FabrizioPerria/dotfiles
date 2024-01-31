return {
  "eandrju/cellular-automaton.nvim",
  config = function()
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

    require("cellular-automaton").register_animation(slide)
  end,
  keys = {
    {
      "<leader>camir",
      "<cmd>CellularAutomaton make_it_rain<CR>",
      "",
    },
    {
      "<leader>caslide",
      "<cmd>CellularAutomaton slide<CR>",
    },
    {
      "<leader>cagol",
      "<cmd>CellularAutomaton game_of_life<CR>",
    },
    {
      "<leader>cascr",
      "<cmd>CellularAutomaton scramble<CR>",
    },
  },
}
