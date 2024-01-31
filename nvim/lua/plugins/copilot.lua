return {
  {
    "zbirenbaum/copilot.lua",
    config = function()
      require("copilot").setup({
        panel = { enabled = false },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<Tab>",
            accept_word = "<M-w>",
            accept_line = "<M-l>",
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
      })
    end,
  },
  {
    "zbirenbaum/copilot-cmp",
    dependencies = "copilot.lua",
    opts = {},
    config = function(_, opts)
      local copilot_cmp = require("copilot_cmp")
      copilot_cmp.setup(opts)
      -- attach cmp source whenever copilot attaches
      -- fixes lazy-loading issues with the copilot cmp source
      require("lazyvim.util").lsp.on_attach(function(client)
        if client.name == "copilot" then
          copilot_cmp._on_insert_enter({})
        end
      end)
    end,
  },
  {
    "L3MON4D3/LuaSnip",
    keys = function()
      return {}
    end,
  },
  -- {
  --   "hrsh7th/cmp-cmdline",
  --   dependencies = { "hrsh7th/nvim-cmp", "hrsh7th/cmp-buffer", "hrsh7th/cmp-path", "L3MON4D3/LuaSnip" },
  --   config = function()
  --     require("cmp").setup.cmdline("/", {
  --       mapping = require("cmp").mapping.preset.cmdline(),
  --       sources = {
  --         { name = "buffer" },
  --         { name = "cmdline" },
  --         { name = "nvim_lua" },
  --         { name = "luasnip" },
  --         { name = "path" },
  --       },
  --     })
  --     require("cmp").setup.cmdline(":", {
  --       mapping = require("cmp").mapping.preset.cmdline(),
  --       sources = require("cmp").config.sources({
  --         { name = "path" },
  --       }, {
  --         {
  --           name = "cmdline",
  --           option = {
  --             ignore_cmds = { "Man", "!" },
  --           },
  --         },
  --       }),
  --     })
  --   end,
  -- }, --   "hrsh7th/nvim-cmp",
  --   dependencies = {
  --     "zbirenbaum/copilot-cmp",
  --     "onsails/lspkind.nvim",
  --   },
  --
  --   opts = function(_, opts)
  --     opts.sources = vim.tbl_extend("force", opts.sources, {
  --       { name = "copilot", group_index = 2 },
  --       { name = "nvim_lsp", group_index = 2 },
  --       { name = "path", group_index = 2 },
  --       { name = "luasnip", group_index = 2 },
  --     })
  --
  --     --      opts.view = vim.tbl_extend("force", opts.view, {
  --     --        entries = {
  --     --          name = "custom",
  --     --          selection_order = "top_down",
  --     --          vertical_positioning = "above",
  --     --        },
  --     --        docs = {
  --     --          auto_open = true,
  --     --        },
  --     --      })
  --     --
  --     --      opts.window = vim.tbl_extend("force", opts.window, {
  --     --        documentation = require("cmp").config.window.bordered(),
  --     --      })
  --     --
  --     --      opts.snippet = vim.tbl_extend("force", opts.snippet, {
  --     --        expand = function(args)
  --     --          require("luasnip").lsp_expand(args.body)
  --     --        end,
  --     --      })
  --
  --     opts.mapping = vim.tbl_extend("force", opts.mapping, {
  --       ["Up"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
  --       ["Down"] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
  --       ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
  --       ["<C-s>"] = require("cmp").mapping.complete({ reason = require("cmp").ContextReason.Auto }),
  --       ["<C-j>"] = require("cmp").mapping.scroll_docs(4),
  --       ["<C-k>"] = require("cmp").mapping.scroll_docs(-4),
  --       ["<C-d>"] = require("cmp").mapping.scroll_docs(4),
  --       ["<C-u>"] = require("cmp").mapping.scroll_docs(-4),
  --       ["<C-e>"] = require("cmp").mapping.close(),
  --       ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
  --       ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
  --       ["<Tab>"] = require("cmp").mapping(function(fallback)
  --         if require("copilot.suggestion").is_visible() then
  --           require("copilot.suggestion").accept()
  --         else
  --           fallback()
  --         end
  --       end, { "i", "s" }),
  --     })
  --     --table.insert(opts.sources, 1, {
  --     --  name = "copilot",
  --     --  group_index = 1,
  --     --  priority = 100,
  --     --})
  --   end,
  -- },
  -- {
}
