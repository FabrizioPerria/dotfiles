return {
  "folke/trouble.nvim",
  cmd = "TroubleToggle",
  config = function()
    require("trouble").setup({
      auto_open = false,
      auto_close = true,
      auto_preview = false,
      auto_fold = false,
      signs = {
        error = " ",
        warning = " ",
        hint = " ",
        information = " ",
        other = " ",
      },
      -- use_lsp_diagnostic_signs = true,
    })
  end,
  keys = {
    {
      "[d",
      function()
        require("trouble").previous({ skip_groups = true, jump = true })
      end,
      "previous item",
    },
    {
      "]d",
      function()
        require("trouble").next({ skip_groups = true, jump = true })
      end,
      "next item",
    },
  },
}
