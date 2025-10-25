local M = {
  -- {
  -- 	"monkoose/neocodeium",
  -- 	event = "VeryLazy",
  -- 	config = function()
  -- 		local neocodeium = require("neocodeium")
  -- 		neocodeium.setup({
  -- 			show_label = false,
  -- 		})
  -- 		vim.keymap.set("i", "<C-f>", function()
  -- 			neocodeium.accept()
  -- 		end)
  -- 		vim.keymap.set("i", "<A-w>", function()
  -- 			neocodeium.accept_word()
  -- 		end)
  -- 		vim.keymap.set("i", "<A-l>", function()
  -- 			neocodeium.accept_line()
  -- 		end)
  -- 		vim.keymap.set("i", "<A-c>", function()
  -- 			neocodeium.clear()
  -- 		end)
  -- 	end,
  -- },
  {
    "supermaven-inc/supermaven-nvim",
    event = "VeryLazy",
    config = function()
      local supermaven = require("supermaven-nvim")
      supermaven.setup({
        keymaps = {
          accept_suggestion = "<A-w>",
          clear_suggestion = "<A-c>",
          accept_word = "<A-l>",
        },
        ignore_filetypes = { ".env" }
      })
    end
  }
}

return M
