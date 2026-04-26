return {
    {
        "theprimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("harpoon"):setup()
        end,
        keys = {
            { "<leader>ha", function() require("harpoon"):list():add() end,     desc = "harpoon add file", },
            {
                "<leader>hs",
                function()
                    local harpoon = require("harpoon")
                    harpoon.ui:toggle_quick_menu(harpoon:list())
                end,
                desc = "harpoon quick menu",
            },
            { "<leader>h1", function() require("harpoon"):list():select(1) end, desc = "harpoon to file 1", },
            { "<leader>h2", function() require("harpoon"):list():select(2) end, desc = "harpoon to file 2", },
            { "<leader>h3", function() require("harpoon"):list():select(3) end, desc = "harpoon to file 3", },
            { "<leader>h4", function() require("harpoon"):list():select(4) end, desc = "harpoon to file 4", },
            { "<leader>h5", function() require("harpoon"):list():select(5) end, desc = "harpoon to file 5", },
            { "<leader>h6", function() require("harpoon"):list():select(6) end, desc = "harpoon to file 6", },
            { "<leader>h7", function() require("harpoon"):list():select(7) end, desc = "harpoon to file 7", },
            { "<leader>h8", function() require("harpoon"):list():select(8) end, desc = "harpoon to file 8", },
            { "<leader>h9", function() require("harpoon"):list():select(9) end, desc = "harpoon to file 9", },
        },
    },
}
