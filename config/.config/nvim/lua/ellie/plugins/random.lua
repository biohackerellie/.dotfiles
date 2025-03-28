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
		"MagicDuck/grug-far.nvim",
		config = function()
			-- optional setup call to override plugin options
			-- alternatively you can set options with vim.g.grug_far = { ... }
			require("grug-far").setup({
				-- options, see Configuration section below
				-- there are no required options atm
				-- engine = 'ripgrep' is default, but 'astgrep' or 'astgrep-rules' can
				-- be specified
			})
		end,
	},
	-- {
	-- 	"biohackerellie/commitr.nvim",
	-- 	lazy = true,
	-- 	cmd = {
	-- 		"Commitr",
	-- 	},
	-- 	keys = {
	-- 		{ "<leader>gc", "<cmd>Commitr<cr>", desc = "Commitr" },
	-- 	},
	-- 	dependencies = {
	-- 		"nvim-lua/plenary.nvim",
	-- 	},
	-- },
}

return M
