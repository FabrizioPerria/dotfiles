local debugprint = require('debugprint')
debugprint.setup({
    create_keymaps = false,
    create_commands = false
})

vim.keymap.set("n", "<Leader>pp", function() return debugprint.debugprint() end, { expr = true, })
vim.keymap.set("n", "<Leader>pP", function() return debugprint.debugprint({ above = true }) end, { expr = true, })
vim.keymap.set("n", "<Leader>pv", function() return debugprint.debugprint({ variable = true }) end, { expr = true, })
vim.keymap.set("n", "<Leader>pV", function() return debugprint.debugprint({ above = true, variable = true }) end, { expr = true, })
vim.keymap.set("n", "<Leader>pm", function() return debugprint.debugprint({ motion = true }) end, { expr = true, })
vim.keymap.set("n", "<Leader>pc", function() return debugprint.deleteprints() end, {})
