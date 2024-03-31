return {
    {
        "nvim-treesitter/nvim-treesitter",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "cmake",
                    "cpp",
                    "css",
                    "dockerfile",
                    "dot",
                    "elvish",
                    "fish",
                    "git_rebase",
                    "gitattributes",
                    "gitcommit",
                    "gitignore",
                    "go",
                    "godot_resource",
                    "gomod",
                    "gowork",
                    "html",
                    "http",
                    "java",
                    "javascript",
                    "jq",
                    "json",
                    "json5",
                    "jsonc",
                    "julia",
                    "kotlin",
                    "latex",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "mermaid",
                    "meson",
                    "ninja",
                    "nix",
                    "org",
                    "python",
                    "regex",
                    "rust",
                    "sql",
                    "svelte",
                    "sxhkdrc",
                    "todotxt",
                    "toml",
                    "typescript",
                    "vim",
                    "yaml",
                    "zig",
                    "vimdoc",
                    "kdl",
                    "c_sharp",
                },
                sync_install = false,
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                incremental_selection = {
                    enable = false,
                    -- enable = true,
                    keymaps = {
                        init_selection = "<C-space>",
                        node_incremental = "<C-space>",
                        scope_incremental = "<C-s>",
                        node_decremental = "<C-BS>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["ii"] = "@conditional.inner",
                            ["ai"] = "@conditional.outer",
                            ["il"] = "@loop.inner",
                            ["al"] = "@loop.outer",
                            ["i/"] = "@comment.inner",
                            ["a/"] = "@comment.outer",
                            ["in"] = "@number.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true, -- whether to set jumps in the jumplist
                        goto_next_start = {
                            ["]a"] = "@parameter.outer",
                            ["]o"] = "@block.outer",
                            ["]c"] = "@class.outer",
                            ["]f"] = "@function.outer",
                            ["]i"] = "@conditional.outer",
                            ["]l"] = "@loop.outer",
                            ["]n"] = "@number.inner",
                            ["]r"] = "@return.outer",
                            ["]/"] = "@comment.outer",
                        },
                        goto_next_end = {
                            ["]A"] = "@parameter.outer",
                            ["]O"] = "@block.outer",
                            ["]C"] = "@class.outer",
                            ["]F"] = "@function.outer",
                            ["]I"] = "@conditional.outer",
                            ["]L"] = "@loop.outer",
                            ["]R"] = "@return.outer",
                        },
                        goto_previous_start = {
                            ["[a"] = "@parameter.outer",
                            ["[o"] = "@block.outer",
                            ["[c"] = "@class.outer",
                            ["[f"] = "@function.outer",
                            ["[i"] = "@conditional.outer",
                            ["[l"] = "@loop.outer",
                            ["[n"] = "@number.inner",
                            ["[r"] = "@return.outer",
                            ["[/"] = "@comment.outer",
                        },
                        goto_previous_end = {
                            ["[A"] = "@parameter.outer",
                            ["[O"] = "@block.outer",
                            ["[C"] = "@class.outer",
                            ["[F"] = "@function.outer",
                            ["[I"] = "@conditional.outer",
                            ["[L"] = "@loop.outer",
                            ["[R"] = "@return.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    },
}
