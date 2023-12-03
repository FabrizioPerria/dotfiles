local configFunction = function(_, opts)
  local wk = require("which-key")
  wk.setup(opts)

  if not vim.g.vscode then
    local function DiffViewToggle()
      if next(require("diffview.lib").views) == nil then
        vim.cmd("DiffviewOpen")
      else
        vim.cmd("DiffviewClose")
      end
    end

    wk.register({
      ["<leader>"] = {

        ["g"] = {
          ["co"] = { ':Git commit -S -m ""<Left>', " ", mode = { "n" }, silent = false },
          ["g"] = { ":Git pull --rebase", " ", silent = false, mode = { "n" } },
          ["p"] = { ":Git push -u origin ", " ", silent = false, mode = { "n" } },
          ["m"] = { ":Git merge ", " ", silent = false, mode = { "n" } },
          ["L"] = {
            "<cmd>vert Git log --show-signature | vertical resize 100<cr>",
            " ",
            silent = false,
            mode = { "n" },
          },
          ["t"] = { "<cmd>GV<cr>", " ", silent = false, mode = { "n" } },
          ["a"] = { "<cmd>Gwrite<cr>", " ", silent = false, mode = { "n" } },
          ["-"] = { "<cmd>Gread<cr>", " ", silent = false, mode = { "n" } },
          ["ch"] = { ":Git checkout ", " ", silent = false, mode = { "n" } },
          ["B"] = { "<cmd>lua require('telescope.builtin').git_branches<cr>", " ", silent = false, mode = { "n" } },
          ["s"] = { "<cmd>lua require('telescope.builtin').git_stash<cr>", " ", silent = false, mode = { "n" } },
          ["sa"] = { "<cmd>Git stash<cr>", " ", silent = false, mode = { "n" } },
          ["sp"] = { "<cmd>Git stash pop<cr>", " ", silent = false, mode = { "n" } },
          ["f"] = { "<cmd>lua require('telescope.builtin').git_files<cr>", " ", silent = false, mode = { "n" } },
          ["l"] = { "<cmd>lua require('telescope.builtin').git_commits<cr>", " ", silent = false, mode = { "n" } },
          ["d"] = { DiffViewToggle, " ", mode = { "n" } },
          ["<Left>"] = { "<cmd>lua require('diffview.actions').diffget('ours')<cr>", " ", mode = { "n", "x" } },
          ["<Right>"] = { "<cmd>lua require('diffview.actions').diffget('theirs')<cr>", " ", mode = { "n", "x" } },
          ["<Down>"] = { "<cmd>lua require('diffview.actions').diffput('local')<cr>", " ", mode = { "n", "x" } },
          ["<Up>"] = { "<C-j>u", " ", mode = { "n", "x" } },
          ["b"] = { "<cmd>GitBlameToggle<cr>", "", silent = false, mode = { "n", "x" } },
        },

        ["t"] = {
          ["n"] = { ":tabedit ", "Open file in new tab", silent = false, mode = { "n" } },
          ["<Left>"] = { "<cmd>tabprev<cr>", "Move to previous tab", silent = false, mode = { "n" } },
          ["<Right>"] = { "<cmd>tabnext<cr>", "Move to next tab", silent = false, mode = { "n" } },
          ["q"] = { "<cmd>tabclose<cr>", "Move to next tab", silent = false, mode = { "n" } },
        },
        ["."] = { "<cmd>lua require('actions-preview').code_actions<cr>", "Code Actions", mode = { "n" } },
      },
    })
  else
    local vscode = require("vscode-neovim")
    wk.register({
      ["J"] = { "<cmd>m '>+1<cr>gv=gv<cr>", "Move selected block up", mode = { "x" } },
      ["K"] = { "<cmd>m '<-2<cr>gv=gv<cr>", "Move selected block down", mode = { "x" } },
      ["Y"] = { "yy", "Alternative copy full line", mode = { "n" } },

      ["<C-d>"] = { "<C-d>zz", "Scroll down and center", mode = { "n", "x" } },
      ["<C-u>"] = { "<C-u>zz", "Scroll up and center", mode = { "n", "x" } },

      ["<leader>"] = {
        ["s"] = {
          function()
            vscode.call("vim-search-and-replace.start")
          end,
          "Find in files",
          mode = { "n", "x" },
        },
        ["f"] = {
          [""] = {
            function()
              vscode.call("editor.action.formatDocument")
            end,
            "Format file",
            mode = { "n" },
          },
          ["f"] = {
            function()
              vscode.call("workbench.action.quickOpen")
            end,
            "Fuzzy file search",
            mode = { "n" },
          },
          ["b"] = {
            function()
              vscode.call("workbench.action.showAllEditors")
            end,
            "Show buffers",
            silent = false,
            mode = {
              "n",
            },
          },
          ["g"] = {
            function()
              vscode.call("workbench.view.scm")
            end,
            "Fuzzy file search in git repository",
            mode = {
              "n",
            },
          },
          ["s"] = {
            function()
              vscode.call("livegrep.search")
            end,
            "Grep search",
            mode = { "n" },
          },
          ["v"] = {
            function()
              vscode.call("workbench.explorer.fileView.focus")
            end,
            "Show file browser",
            silent = false,
            mode = {
              "n",
            },
          },
          ["p"] = {
            [""] = {
              function()
                vscode.call("projectManager.listFavoriteProjects#sideBarFavorites")
              end,
              "Show marked projects",
              silent = false,
              mode = {
                "n",
              },
            },
            ["a"] = {
              function()
                vscode.call("projectManager.addToFavorites")
              end,
              "Add to projects",
              mode = {
                "n",
              },
            },
          },
        },

        ["g"] = {
          [""] = {
            function()
              vscode.call("workbench.view.scm")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["co"] = {
            function()
              vscode.call("git.commit")
            end,
            " ",
            mode = { "n" },
            silent = false,
          },
          ["g"] = {
            function()
              vscode.call("git.pullRebase")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["p"] = {
            function()
              vscode.call("git.push")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["m"] = {
            function()
              vscode.call("git.merge")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["t"] = {
            function()
              vscode.call("git-graph.view")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["ch"] = {
            function()
              vscode.call("git.checkout")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["sa"] = {
            function()
              vscode.call("git.stash")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["sp"] = {
            function()
              vscode.call("git.stashPop")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["l"] = {
            function()
              vscode.call("git.viewHistory")
            end,
            " ",
            silent = false,
            mode = { "n" },
          },
          ["b"] = {
            function()
              vscode.call("gitlens.toggleLineBlame")
            end,
            "",
            silent = false,
            mode = { "n", "x" },
          },
        },

        ["h"] = {
          ["a"] = {
            function()
              vscode.call("vscode-harpoon.addEditor")
            end,
            "Add file",
          },
          ["s"] = {
            function()
              vscode.call("vscode-harpoon.editorQuickPick")
            end,
            "Show files",
          },
          ["1"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor1")
            end,
            "Open mark 1",
          },
          ["2"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor2")
            end,
            "Open mark 2",
          },
          ["3"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor3")
            end,
            "Open mark 3",
          },
          ["4"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor4")
            end,
            "Open mark 4",
          },
          ["5"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor5")
            end,
            "Open mark 5",
          },
          ["6"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor6")
            end,
            "Open mark 6",
          },
          ["7"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor7")
            end,
            "Open mark 7",
          },
          ["8"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor8")
            end,
            "Open mark 8",
          },
          ["9"] = {
            function()
              vscode.call("vscode-harpoon.gotoEditor9")
            end,
            "Open mark 9",
          },
        },

        ["t"] = {
          [""] = {
            function()
              vscode.call("workbench.action.terminal.focus")
            end,
            "Enable Terminal",
            mode = { "n" },
          },
          ["t"] = {
            function()
              vscode.call("todohighlight.listAnnotations")
            end,
            "Show todo list",
            mode = { "n" },
          },
        },
        ["v"] = {
          ["s"] = {
            function()
              vscode.call("workbench.action.gotoSymbol")
            end,
            "",
            mode = { "n" },
          },
          ["r"] = {
            function()
              vscode.call("editor.action.goToReferences")
            end,
            "",
            mode = { "n" },
          },
          ["d"] = {
            function()
              vscode.call("editor.action.goToDeclaration")
            end,
            "",
            mode = { "n" },
          },
          ["i"] = {
            function()
              vscode.call("editor.action.goToImplementation")
            end,
            "",
            mode = { "n" },
          },
          [";"] = {
            function()
              vscode.call("editor.action.showHover")
            end,
            "",
            mode = { "n" },
          },
          ["rn"] = {
            function()
              vscode.call("editor.action.rename")
            end,
            "",
            mode = { "n" },
          },
        },
        ["y"] = { [["+y]], "copy selection to system clipboard", mode = { "n", "x" } },
        ["Y"] = { [["+Y]], "Copy current line to system clipboard", mode = { "n" } },
        ["/"] = {
          function()
            vscode.call("editor.action.commentLine")
          end,
          "Comment selection",
          mode = { "n", "x" },
        },
        ["="] = {
          function()
            local buf = vim.api.nvim_get_current_buf()
            local row = vim.api.nvim_win_get_cursor(0)[1]
            local sep =
              "===================================================================================================="
            vim.api.nvim_buf_set_lines(buf, row, row, false, { sep })
            vim.api.nvim_win_set_cursor(0, { row + 1, 0 })
            vscode.action("editor.action.commentLine")
          end,
          "Comment selection",
          mode = { "n" },
        },
      },

      [";"] = {
        require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_next,
        "next match",
        mode = { "n", "x", "o" },
      },
      [","] = {
        require("nvim-treesitter.textobjects.repeatable_move").repeat_last_move_previous,
        "previous match",
        mode = { "n", "x", "o" },
      },

      ["f"] = {
        "<cmd>lua require('nvim-treesitter.textobjects.repeatable_move').builtin_f<cr>",
        " ",
        mode = { "n", "x", "o" },
      },
      ["F"] = {
        "<cmd>lua require('nvim-treesitter.textobjects.repeatable_move').builtin_F<cr>",
        " ",
        mode = { "n", "x", "o" },
      },
      ["t"] = {
        "<cmd>lua require('nvim-treesitter.textobjects.repeatable_move').builtin_t<cr>",
        " ",
        mode = { "n", "x", "o" },
      },
      ["T"] = {
        "<cmd>lua require('nvim-treesitter.textobjects.repeatable_move').builtin_T<cr>",
        " ",
        mode = { "n", "x", "o" },
      },
    })
  end
end

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "nvim-telescope/telescope-file-browser.nvim",
    "nvim-telescope/telescope-fzf-native.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-project.nvim",
    "debugloop/telescope-undo.nvim",
    "nvim-telescope/telescope-packer.nvim",
    "nvim-telescope/telescope-dap.nvim",
    "theprimeagen/refactoring.nvim",
    "mfussenegger/nvim-dap",
    "nvim-treesitter/nvim-treesitter",
    "nvim-treesitter/nvim-treesitter-context",
    "nvim-treesitter/nvim-treesitter-textobjects",
    "sindrets/diffview.nvim",
    "nvim-lua/plenary.nvim",
  },
  opts = {
    plugins = { spelling = true },
    defaults = {},
  },
  config = configFunction,
}
