local configFunction = function(_, opts)
  local wk = require("which-key")
  wk.setup(opts)

  if vim.g.vscode then
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
  opts = {
    plugins = { spelling = true },
    defaults = {},
  },
  config = configFunction,
}
