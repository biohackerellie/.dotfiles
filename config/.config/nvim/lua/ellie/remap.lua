vim.g.mapleader = " "

-- spectre
vim.keymap.set("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
vim.keymap.set("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
vim.keymap.set("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
vim.keymap.set("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})

local hover = require("hover")
-- hover
vim.keymap.set("n", "K", hover.hover, { desc = "hover.nvim" })

vim.keymap.set("n", "gK", hover.hover_select, { desc = "hover.nvim (select)" })

vim.keymap.set("n", "<MouseMove>", hover.hover_mouse, { desc = "hover.nvim (mouse)" })

-- undotree

vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
