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
    return {
        "eandrju/cellular-automaton.nvim",     
        enabled = vim.g.vscode == 0,
        config = function() require("cellular-automaton").register_animation(slide) end
    }