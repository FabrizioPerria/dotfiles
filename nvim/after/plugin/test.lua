require("neotest").setup({
    adapters = {
        -- require("neotest-dotnet"),
        require("neotest-gtest").setup({})
        -- require("neotest-python")
    }
})
