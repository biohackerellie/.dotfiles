local M = {
	{
		"eandrju/cellular-automaton.nvim",
		event = "VeryLazy",
		keys = {
			{ "<leader>fml", "<cmd>CellularAutomaton make_it_rain<CR>", desc = "make it rain baby" },
		},
	},
	{
		"tamton-aquib/duck.nvim",
    --stylua: ignore
    keys = {
      {"<leader>dd", function() require("duck").hatch() end, desc = "Hatch a duck"},
      {"<leader>dk", function() require("duck").cook() end, desc = "Cook a duck"},
      {"<leader>da", function() require("duck").cook_all() end, desc = "Cook all the ducks"},
    },
	},
	{
		"HiPhish/rainbow-delimiters.nvim",
		event = "VeryLazy",
	},
	{
		"David-Kunz/cmp-npm",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		config = function()
			require("cmp-npm").setup({})
		end,
	},
}

return M
