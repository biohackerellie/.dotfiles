local M = {
	"folke/tokyonight.nvim",
	name = "tokyonight",
	lazy = false,
	priority = 1000,
	config = function()
		local transparent = require("ellie.config").transparent

		require("tokyonight").setup({
			transparent = transparent,
			styles = {
				keywords = { italic = true },
				functions = { italic = true },
			},
      lualine_bold = true,
			plugins = {
        neotree = true,
				mason = true,
				noice = true,
				notify = true,
				neotest = true,
				which_key = true,
        telescope = true,
        copilot = true,
        lazy = true,
			},
      cache = true,
		})
		vim.cmd.colorscheme("tokyonight-moon")
	end,
}

return M
