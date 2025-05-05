local M = {}
local lsp_util = require("lspconfig.util")
M.config = {
	root_dir = function(fname)
		return lsp_util.root_pattern(
			"tailwind.config.js",
			"tailwind.config.cjs",
			"tailwind.config.mjs",
			"tooling/tailwind/*.ts"
		)(fname)
	end,
	settings = {
		tailwindCSS = {

			validate = true,
			lint = {
				cssConflict = "warning",
				invalidApply = "error",
				invalidScreen = "error",
				invalidVariant = "error",
				invalidConfigPath = "error",
				invalidTailwindDirective = "error",
				recommendedVariantOrder = "warning",
			},
			classAttributes = {
				"class",
				"className",
				"class:list",
				"classList",
				"ngClass",
			},
			includeLanguages = {
				eelixir = "html-eex",
				eruby = "erb",
				templ = "html",
				htmlangular = "html",
			},
			experimental = {
				classRegex = {
					-- clsx, cn
					-- https://github.com/tailwindlabs/tailwindcss-intellisense/issues/682#issuecomment-1364585313
					{ [[clsx\(([^)]*)\)]], [["([^"]*)"]] },
					{ [[cn\(([^)]*)\)]], [["([^"]*)"]] },
					-- Tailwind Variants
					-- https://www.tailwind-variants.org/docs/getting-started#intellisense-setup-optional
					{ [[tv\(([^)]*)\)]], [==[["'`]([^"'`]*).*?["'`]]==] },
				},
			},
		},
	},
}

return M
