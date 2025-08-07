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
		"folke/zen-mode.nvim",
		cmd = "ZenMode",
		keys = {
			{ "<leader>zm", "<cmd>ZenMode<cr>", desc = "ZenMode" },
		},
		opts = {},
	},
	{
		"MagicDuck/grug-far.nvim",
	},
	{
		"sphamba/smear-cursor.nvim",
		cmd = "SmearCursorToggle",
		opts = {
			smear_between_buffers = true,
			smear_between_neighbor_lines = true,
			scroll_buffer_space = true,
			smear_insert_mode = true,
			legacy_computing_symbols_support = true,
		},
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
