local ts = require("nvim-treesitter")

local parsers = {
    "xml",
    "graphql",
    "bash",
    "c",
    "cmake",
    "cpp",
    "css",
    "dockerfile",
    "dot",
    "fish",
    "git_rebase",
    "gitattributes",
    "gitcommit",
    "gitignore",
    "go",
    "gomod",
    "gowork",
    "html",
    "http",
    "java",
    "javascript",
    "jq",
    "json",
    "json5",
    "kotlin",
    "lua",
    "make",
    "markdown",
    "markdown_inline",
    "mermaid",
    "meson",
    "ninja",
    "nix",
    "python",
    "regex",
    "rust",
    "sql",
    "svelte",
    "toml",
    "typescript",
    "vim",
    "yaml",
    "zig",
    "vimdoc",
    "kdl",
    "c_sharp",
    "vue",
}

ts.install(parsers, { summary = false }):wait(30000)

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter_features", { clear = true }),
    pattern = "*",
    callback = function(event)
        local lang = vim.treesitter.language.get_lang(event.match) or event.match
        if vim.api.nvim_buf_line_count(event.buf) > 5000 then
            return
        end
        local ok = pcall(vim.treesitter.start, event.buf, lang)
        if ok then
            vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

require("nvim-treesitter-textobjects").setup({
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
        set_jumps = true,
        goto_next_start = {
            ["]a"] = "@parameter.outer",
            ["]o"] = "@block.outer",
            ["]c"] = "@class.outer",
            ["]f"] = "@function.outer",
            ["]i"] = "@conditional.outer",
            ["]l"] = "@loop.outer",
            ["]n"] = "@number.inner",
            ["]r"] = "@return.outer",
            ["]["] = "@comment.outer",
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
        swap_next = { ["<leader>a"] = "@parameter.inner" },
        swap_previous = { ["<leader>A"] = "@parameter.inner" },
    },
})
