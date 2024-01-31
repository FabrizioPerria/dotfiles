local function prompt()
  vim.fn.input("Condition: ")
end

return {
  {
    "mfussenegger/nvim-dap",
    keys = {
      { "<F5>", ":DapContinue<CR>", "Run/Continue Debug" },
      {
        "<F8>",
        function()
          require("dap").set_breakpoint(prompt())
        end,
        "Conditional Breakpoint",
      },
      { "<F9>", ":DapToggleBreakpoint<CR>", "Toggle Breakpoint" },
      { "<F10>", ":DapStepOver<CR>", "Debug step over" },
      { "<F11>", ":DapStepInto<CR>", "Debug step into" },
      { "<C-F11>", ":DapStepOut<CR>", "Debug step out" },
      { "<F12>", ':DapTerminate<CR>:lua require"dapui".close()<CR>', "" },
    },
  },
}
