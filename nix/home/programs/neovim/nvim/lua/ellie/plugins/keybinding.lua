local M = {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts = {
		plugins = {
			presets = {
				operators = true,
				motions = true,
				text_objects = false,
				windows = false,
				nav = true,
				z = true,
				g = false,
			},
		},
		icons = {
			breadcrumb = "",
			separator = " ",
			group = "",
		},
		win = {
			border = require("ellie.config").get_border(),
		},
		layout = {
			spacing = 5,
			align = "center",
		},
		show_help = false,
	},
	config = function(_, opts)
		local wk = require("which-key")
		wk.setup(opts)
		wk.add({
			{ "]", group = "Next" },
			{ "[", group = "Prev" },

			{ "<leader>b", name = " Buffer" },
			{ "<leader>c", group = " Code" },
			{ "<leader>d", group = " Debug" },
			{ "<leader>f", group = " Find" },
			{ "<leader>g", group = " Git" },
			{ "<leader>l", group = " LSP" },
			{ "<leader>m", group = " Markdown" },
			{ "<leader>n", group = "󰵚 Notification" },
			{ "<leader>t", group = " Test" },
			{ "<leader>o", group = "󰘵 Option" },
			{ "<leader>p", group = " Package" },
			{ "<leader>q", group = "🤠 Sessions" },
			{ "<leader>M", group = "Motions" },
		})
	end,
}

return M
