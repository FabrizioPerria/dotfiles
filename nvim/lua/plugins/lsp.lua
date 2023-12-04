vim.g.copilot_no_tab_map = true
vim.g.copilot_assume_mapped = true
vim.g.copilot_tab_fallback = ""
return {
  {
    "Issafalcon/lsp-overloads.nvim",
    vscode = false,
  },
  {
    "onsails/lspkind.nvim",
    vscode = false,
    opts = {
      symbol_map = {
        Copilot = "",
      },
    },
    config = function(_, opts)
      require("lspkind").init(opts)
      require("cmp").formatting = {
        format = require("lspkind").cmp_format({
          mode = "symbol_text", -- show only symbol annotations
          maxwidth = 80, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
          ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
        }),
      }
    end,
  },
  {
    "llllvvuu/nvim-cmp",
    vscode = false,
    branch = "feat/above",
    dependencies = {
      "zbirenbaum/copilot.lua",
      "onsails/lspkind.nvim",
    },
    opts = {
      sources = {
        { name = "copilot", group_index = 2 },
        { name = "nvim_lsp", group_index = 2 },
        { name = "path", group_index = 2 },
        { name = "luasnip", group_index = 2 },
      },

      view = {
        entries = {
          name = "custom",
          selection_order = "top_down",
          vertical_positioning = "above",
        },
        docs = {
          auto_open = true,
        },
      },

      mapping = require("cmp").mapping.preset.insert({
        ["Up"] = require("cmp").mapping.select_prev_item({ behavior = require("cmp").SelectBehavior.Select }),
        ["Down"] = require("cmp").mapping.select_next_item({ behavior = require("cmp").SelectBehavior.Select }),
        ["<CR>"] = require("cmp").mapping.confirm({ select = true }),
        ["<C-s>"] = require("cmp").mapping.complete({ reason = require("cmp").ContextReason.Auto }),
        ["<C-j>"] = require("cmp").mapping.scroll_docs(4),
        ["<C-k>"] = require("cmp").mapping.scroll_docs(-4),
        ["<C-d>"] = require("cmp").mapping.scroll_docs(4),
        ["<C-u>"] = require("cmp").mapping.scroll_docs(-4),
        ["<C-e>"] = require("cmp").mapping.close(),
        ["<C-f>"] = require("cmp").mapping.scroll_docs(4),
        ["<C-b>"] = require("cmp").mapping.scroll_docs(-4),
        ["<Tab>"] = require("cmp").mapping(function(fallback)
          if require("copilot.suggestion").is_visible() then
            require("copilot.suggestion").accept()
          else
            fallback()
          end
        end, { "i", "s" }),
      }),
    },
  },
  -- {
  --   "ray-x/lsp_signature.nvim",
  --   vscode = false,
  --   opts = {
  --     bind = true, -- This is mandatory, otherwise border config won't get registered.
  --     handler_opts = {
  --       border = "rounded",
  --     },
  --   },
  --   config = function(_, opts)
  --     require("lsp_signature").setup(opts)
  --   end,
  -- },

  {
    "neovim/nvim-lspconfig",
    vscode = false,
    opts = {
      autoformat = false,
    },
    config = function()
      local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    vscode = false,
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    opts = {

      ensure_installed = {
        "clangd",
        "cmake",
        "bashls",
        "cmake",
        "pyright",
        "zk",
        "lua_ls",
        "vimls",
        "efm",
        "csharp_ls",
        "grammarly",
        -- 'clang-format',
        -- 'codelldb',
        -- 'cpptools',
        -- 'debugpy',
        -- 'glow',
        -- 'netcoredbg',
        -- 'prettier',
        -- 'shfmt',
        -- 'stylua',
      },
      handlers = {
        -- lsp_zero.default_setup,
        bashls = function()
          require("lspconfig").bashls.setup({
            filetypes = {
              "sh",
              "bash",
            },
          })
        end,
        cmake = function()
          require("lspconfig").cmake.setup({
            cmd = { "/opt/homebrew/bin/cmake-language-server" },
            filetypes = {
              "cmake",
              "CMakeLists.txt",
            },
          })
        end,
        lua_ls = function()
          require("lspconfig").lua_ls.setup({
            settings = {
              Lua = {
                diagnostics = {
                  globals = { "vim" },
                },
              },
            },
          })
        end,
        clangd = function()
          require("lspconfig").clangd.setup({
            cmd = { "/opt/homebrew/opt/llvm/bin/clangd", "--background-index" },
            filetypes = { "c", "cpp", "h", "hpp", "objc", "objcpp" },
            root_dir = function(fname)
              return require("lspconfig").util.root_pattern("compile_commands.json", "compile_flags.txt", ".git")(fname)
                or vim.fn.getcwd()
            end,
            on_attach = function(_, bufnr)
              vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")
            end,
          })
        end,
      },
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
      vim.diagnostic.config({
        underline = true,
        signs = true,
        virtual_text = true,
        float = {
          show_header = true,
          source = "always",
          border = "rounded",
          focusable = false,
        },
        update_in_insert = false, -- default to false
        severity_sort = false, -- default to false
      })
    end,
  },
}
