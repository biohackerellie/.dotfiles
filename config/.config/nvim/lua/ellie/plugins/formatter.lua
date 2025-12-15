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
				go = { "goimports", "gofumpt" },
				gdscript = { "gdformat" },
				python = { "ruff_fix", "ruff_format" },
				rust = { "rustfmt" },
				templ = { "templ", "injected" },
			},
			format_on_save = function()
				if
					vim.bo.filetype == "templ"
					and #vim.diagnostic.get(0, { severity = { min = vim.diagnostic.severity.ERROR } }) > 0
				then
					vim.lsp.buf.format({ async = true })
					return nil
				end
				return {
					timeout_ms = 500,
					lsp_fallback = true,
				}
			end,
		})
	end,
}
