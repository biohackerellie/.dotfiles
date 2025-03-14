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
        javascript = { "biome"},
        typescript = { "biome"},
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

			require("conform.formatters.biome").args = function(_, ctx)
				local biome_roots = {
		      "biome.json",
          "biome.jsonc",
				}
				local args = { "--stdin-filepath", "$FILENAME" }
				local config_path = vim.fn.stdpath("config") .. "/lua/ellie/config/"

				local localBiomeConfig = vim.fs.find(biome_roots, {
					upward = true,
					path = ctx.dirname,
					type = "file",
				})[1]
				local globalBiomeConfig = vim.fs.find(biome_roots, {
					path = type(config_path) == "string" and config_path or config_path[1],
					type = "file",
				})[1]
				local disableGlobalBiomeConfig = os.getenv("DISABLE_GLOBAL_Biome_CONFIG")

				-- Project config takes precedence over global config
				if localBiomeConfig then
					vim.list_extend(args, { "--config", localBiomeConfig })
				elseif globalBiomeConfig and not disableGlobalBiomeConfig then
					vim.list_extend(args, { "--config", globalBiomeConfig })
				end

				return args
			end
		end,
	},
}
