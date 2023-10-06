local slide = {
    fps = 50,
    name = 'slide',
    update = function(grid)
        for i = 1, #grid do
            local prev = grid[i][#(grid[i])]
            for j = 1, #(grid[i]) do
                grid[i][j], prev = prev, grid[i][j]
            end
        end
        return true
    end
}

require("cellular-automaton").register_animation(slide)
vim.keymap.set("n", "<leader>mir", "<cmd>CellularAutomaton make_it_rain<CR>", {desc='Make it rain'});
vim.keymap.set("n", "<leader>gol", "<cmd>CellularAutomaton game_of_life<CR>", {desc='Game of life'});
vim.keymap.set("n", "<leader>scr", "<cmd>CellularAutomaton scramble<CR>", {desc='Scramble'});
vim.keymap.set("n", "<leader>sli", "<cmd>CellularAutomaton slide<CR>", {desc='Slide'});
