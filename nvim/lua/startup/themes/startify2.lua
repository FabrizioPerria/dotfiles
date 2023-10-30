local function getPath(str)
    return str:match("(.*[/\\])")
end

local user_bookmarks = vim.g.startup_bookmarks

local bookmark_texts = { "Bookmarks", "" }
local user_bookmark_mappings = {}

if not user_bookmarks then
    user_bookmarks = {}
    bookmark_texts = {}
else
    for key, file in pairs(user_bookmarks) do
        bookmark_texts[#bookmark_texts + 1] = key .. " " .. file
        user_bookmark_mappings[key] = "<cmd>e " .. file .. "<CR>" .. "<cmd>cd " .. getPath(file) .. "<CR>"
    end
end

bookmark_texts = { "", "Projects", "" }
local keys = 'abcdefghijklmnopqrstuvwxyz'
local index = 0
local key
local projects = require("telescope._extensions.project.utils").get_projects('recent')

for _, project in pairs(projects) do
    index = (index % #keys) + 1
    key = keys:sub(index, index)
    key = '<F' .. index .. '>'
    user_bookmark_mappings[key] = "<cmd>e " .. project.path .. "<CR>" .. "<cmd>cd " .. project.path .. "<CR>"
    bookmark_texts[#bookmark_texts + 1] = '[' .. key .. ']' .. " " .. project.path
end

local cow = {
    "        \\   ^__^",
    "         \\  (oo)\\_______",
    "            (__)\\       )\\/\\",
    "                ||----w |",
    "                ||     ||",
}

local function get_quote_from_fortune(stdout)
    local quote = { "" }
    local lines = {}
    for s in stdout:gmatch("[^\r\n]+") do
        lines[#lines + 1] = s:gsub("^%s+", ""):gsub("%s+$", "")
    end

    for _, v in ipairs(lines) do
        quote[#quote + 1] = v
    end
    return quote
end

local function get_quote_from_theme()
    local quote = require("startup.functions").quote()
    while true do
        if require("startup.utils").longest_line(quote) <= vim.o.columns - 15 then
            break
        end
        quote = require("startup.functions").quote()
    end
    return quote
end

local complete = {}
local quote = { "" }
local handle = io.popen('fortune')
if handle ~= nil then
    local output = handle:read('*a')
    if #output < 1 then
        quote = get_quote_from_theme()
    else
        quote = get_quote_from_fortune(output)
    end
end
quote[#quote + 1] = ""

local length = require("startup.utils").longest_line(quote) + 4

table.insert(complete, "▛" .. string.rep("▀", length - 2) .. "▜")
local function spaces(amount)
    return string.rep(" ", amount)
end
for _, line in ipairs(quote) do
    table.insert(
        complete,
        "▌" .. " " .. line .. spaces(length - 3 - #line) .. "▐"
    )
end
table.insert(complete, "▙" .. string.rep("▄", length - 2) .. "▟")

for _, line in ipairs(cow) do
    complete[#complete + 1] = line
end

-- NOTE: lua dump(vim.fn.expand("#<1")) to get newest oldfile

local settings = {
    header = {
        type = "text",
        oldfiles_directory = false,
        align = "left",
        fold_section = false,
        title = "Header",
        margin = 5,
        content = complete,
        highlight = "Statement",
        default_color = "",
        oldfiles_amount = 0,
    },
    body = {
        type = "oldfiles",
        oldfiles_directory = false,
        align = "left",
        fold_section = false,
        title = "Oldfiles",
        margin = 5,
        content = "",
        highlight = "String",
        default_color = "",
        oldfiles_amount = 5,
    },
    body_2 = {
        type = "oldfiles",
        oldfiles_directory = true,
        align = "left",
        fold_section = false,
        title = "",
        margin = 5,
        content = "",
        highlight = "String",
        oldfiles_amount = 5,
    },
    bookmarks = {
        type = "text",
        align = "left",
        margin = 5,
        content = bookmark_texts,
        highlight = "String",
    },
    options = {
        after = function()
            require("startup").create_mappings(user_bookmark_mappings)
            require("startup.utils").oldfiles_mappings()
        end,
        mapping_keys = false,
        cursor_column = 0.25,
        empty_line_between_mappings = false,
        disable_statuslines = true,
        paddings = { 1, 1, 1, 1 },
    },
    mappings = {
        execute_command = "<CR>",
        open_file = "o",
        open_file_split = "<c-v>",
        open_section = "<TAB>",
        open_help = "?",
    },
    colors = {
        background = "#1f2227",
        folded_section = "#56b6c2",
    },
    parts = { "header", "body", "body_2", "bookmarks" },
}

return settings
