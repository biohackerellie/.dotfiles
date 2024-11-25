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
				gdscript = { "gdformat" },
				python = { "ruff_fix", "ruff_format" },
				rust = { "rustfmt" },
			},
			formatters = {
				shfmt = { prepend_args = { "-i", "2", "-ci" } },

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
		config = function(_, opts)
			local conform = require("conform")
			conform.setup(opts)

			require("conform.formatters.prettier").args = function(_, ctx)
				local prettier_roots = {
					".prettierrc",
					".prettierrc.json",
					".prettierrc.yaml",
					".prettierrc.yml",
					".prettierrc.js",
					"prettier.config.js",
					"tooling/prettier-config/index.js",
				}
				local args = { "--stdin-filepath", "$FILENAME" }
				local config_path = vim.fn.stdpath("config") .. "/lua/ellie/config/"

				local localPrettierConfig = vim.fs.find(prettier_roots, {
					upward = true,
					path = ctx.dirname,
					type = "file",
				})[1]
				local globalPrettierConfig = vim.fs.find(prettier_roots, {
					path = type(config_path) == "string" and config_path or config_path[1],
					type = "file",
				})[1]
				local disableGlobalPrettierConfig = os.getenv("DISABLE_GLOBAL_PRETTIER_CONFIG")

				-- Project config takes precedence over global config
				if localPrettierConfig then
					vim.list_extend(args, { "--config", localPrettierConfig })
				elseif globalPrettierConfig and not disableGlobalPrettierConfig then
					vim.list_extend(args, { "--config", globalPrettierConfig })
				end

				local hasTailwindPrettierPlugin = vim.fs.find("node_modules/prettier-plugin-tailwindcss", {
					upward = true,
					path = ctx.dirname,
					type = "directory",
				})[1]

				if hasTailwindPrettierPlugin then
					vim.list_extend(args, { "--plugin", "prettier-plugin-tailwindcss" })
				end
				return args
			end
		end,
	},
}
