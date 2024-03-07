return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    config = function()
        require("harpoon"):setup()
    end,
    keys = {
        {
            "<leader>ha",
            function()
                require("harpoon"):list():append()
            end,
            "Add file",
        },
        {
            "<leader>hs",
            function()
                require("harpoon").ui:toggle_quick_menu(require("harpoon"):list())
            end,
            "Show files",
        },
        {
            "<leader>h1",
            function()
                require("harpoon"):list():select(1)
            end,
            "Open mark 1",
        },
        {
            "<leader>h2",
            function()
                require("harpoon"):list():select(2)
            end,
            "Open mark 2",
        },
        {
            "<leader>h3",
            function()
                require("harpoon"):list():select(3)
            end,
            "Open mark 3",
        },
        {
            "<leader>h4",
            function()
                require("harpoon"):list():select(4)
            end,
            "Open mark 4",
        },
        {
            "<leader>h5",
            function()
                require("harpoon"):list():select(5)
            end,
            "Open mark 5",
        },
        {
            "<leader>h6",
            function()
                require("harpoon"):list():select(6)
            end,
            "Open mark 6",
        },
        {
            "<leader>h7",
            function()
                require("harpoon"):list():select(7)
            end,
            "Open mark 7",
        },
        {
            "<leader>h8",
            function()
                require("harpoon"):list():select(8)
            end,
            "Open mark 8",
        },
        {
            "<leader>h9",
            function()
                require("harpoon"):list():select(9)
            end,
            "Open mark 9",
        },
    },
}
