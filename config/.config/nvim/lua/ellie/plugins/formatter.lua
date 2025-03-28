return {

	"stevearc/conform.nvim",
	cmd = "ConformInfo",
	event = { "BufWritePre" },
	keys = {
		{
			"<leader>fd",
			function()
				require("conform").format({ async = true, lsp_format = "fallback" })
			end,
			mode = "",
			desc = "[F]ormat [D]ocument",
		},
	},
	config = function()
		local conform = require("conform")
		conform.setup({
			extra_lang_opts = {
				go = {
					lsp_format = "last",
				},
				rust = {
					lsp_format = "last",
				},
			},
			formatters_by_ft = {
				sh = { "shfmt" },
				lua = { "stylua" },
				go = { "goimports" },
				gdscript = { "gdformat" },
				python = { "ruff_fix", "ruff_format" },
				rust = { "rustfmt" },
				["javascript"] = { "biome" },
				["javascriptreact"] = { "biome" },
				["typescript"] = { "biome" },
				["typescriptreact"] = { "biome" },
			},
			format_on_save = {
				enabled = true,
				lsp_fallback = true,
				async = false,
			},
		})
	end,
}
