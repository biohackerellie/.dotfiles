local M = {
	"folke/persistence.nvim",
	event = "BufReadPre",
	opts = {
		dir = vim.fn.stdpath("state") .. ".nvim/sessions/",
	},
}

return M
