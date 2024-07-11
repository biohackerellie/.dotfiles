return {
	{
		"stevearc/conform.nvim",
		cmd = "ConformInfo",
		init = function()
			vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
			require("ellie.util").on_very_lazy(function()
				require("ellie.util").format.formatter = {
					name = "conform.nvim",
					format = function(buf)
						local ft = vim.bo[buf].filetype
						local opts = require("ellie.util").opts("conform.nvim")
						local extra_args = opts.extra_lang_opts[ft] or {}
						require("conform").format(vim.tbl_deep_extend("force", { bufnr = buf }, extra_args))
					end,
				}
			end)
		end,
		opts = {
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
				javascript = { "prettier" },
				typescript = { "prettier" },
				vue = { "eslint_d", "stylelint" },
				python = { "ruff_fix", "ruff_format" },
			},
			formatters = {
				shfmt = { prepend_args = { "-i", "2", "-ci" } },
				prettier = {
					args = function(ctx)
						local args = { "--stdin-filepath", "$FILENAME" }
						local found =
							vim.fn.find("**/prettier-config/index.js", { upward = true, path = ctx.dirname })[1]
						if found then
							vim.list_extend(args, { "--config", found })
						end
						return args
					end,
				},
				stylelint = {
					condition = function(self, ctx)
						return vim.fs.find(
							{ ".stylelintrc", "stylelint.config.js", "stylelint.config.cjs" },
							{ path = ctx.filename, upward = true }
						)[1]
					end,
				},
			},
		},
	},
}
