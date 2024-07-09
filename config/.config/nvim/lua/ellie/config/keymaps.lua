
local Util = require("ellie.util")
local keymap = vim.keymap.set


vim.g.mapleader = " "



-- spectre
keymap("n", "<leader>S", '<cmd>lua require("spectre").toggle()<CR>', {
	desc = "Toggle Spectre",
})
keymap("n", "<leader>sw", '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
	desc = "Search current word",
})
keymap("v", "<leader>sw", '<esc><cmd>lua require("spectre").open_visual()<CR>', {
	desc = "Search current word",
})
keymap("n", "<leader>sp", '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
	desc = "Search on current file",
})



-- undotree

keymap("n", "<leader>u", vim.cmd.UndotreeToggle)

-- diagnostic
local diagnostic_goto = function(next, severity)
  local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
  severity = severity and vim.diagnostic.severity[severity] or nil
  return function()
    go({ severity = severity })
  end
end
keymap("n", "<leader>cd", function()
  vim.diagnostic.open_float({ scope = "cursor", force = false })
end, { desc = "Line Diagnostic" })
keymap("n", "]d", diagnostic_goto(true), { desc = "Next Diagnostic" })
keymap("n", "[d", diagnostic_goto(false), { desc = "Prev Diagnostic" })
keymap("n", "]e", diagnostic_goto(true, "ERROR"), { desc = "Next Error" })
keymap("n", "[e", diagnostic_goto(false, "ERROR"), { desc = "Prev Error" })
keymap("n", "]w", diagnostic_goto(true, "WARN"), { desc = "Next Warning" })
keymap("n", "[w", diagnostic_goto(false, "WARN"), { desc = "Prev Warning" })

keymap("n", "<leader>pl", "<CMD>Lazy<CR>", { desc = "Lazy" })

-- stylua: ignore start

-- Lazygit
keymap("n", "<leader>gg", function() Util.terminal({ "lazygit" }) end, { desc = "Lazygit" })

-- Code format
keymap("n", "<leader>of", function() Util.format.toggle() end, { desc = "Toggle auto format(global)" })
keymap("n", "<leader>oF", function() Util.format.toggle(true) end, { desc = "Toggle auto format(buffer)" })
keymap({ "n", "v" }, "<leader>cf", function() Util.format.format({ force = true }) end, { desc = "Code format" })


keymap("n", "<leader>oh", function() Util.toggle.inlay_hints() end, { desc = "Toggle Inlay Hints" })
keymap("n", "<leader>os", function() Util.toggle("spell") end, { desc = "Toggle spelling" })

keymap("n", "<leader>ow", function() Util.toggle("wrap") end, { desc = "Toggle word wrap" })