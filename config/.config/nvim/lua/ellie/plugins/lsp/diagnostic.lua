local fmt = string.format

local M = {}

function M.setup()
	local icons = require("ellie.config").icons.diagnostics
	local tsTranslator = require("ts-error-translator")
	tsTranslator.setup()

	vim.diagnostic.config({
		signs = {
			text = {
				[vim.diagnostic.severity.ERROR] = icons.error,
				[vim.diagnostic.severity.WARN] = icons.warn,
				[vim.diagnostic.severity.HINT] = icons.hint,
				[vim.diagnostic.severity.INFO] = icons.info,
			},
		},
		severity_sort = true,
		virtual_text = {
			source = false,
			spacing = 2,
			prefix = "●",
		},
		-- virtual_lines = { current_line = true },
		float = {
			header = "",
			source = false,
			border = require("ellie.config").get_border(),
			prefix = function(d)
				local level = vim.diagnostic.severity[d.severity]
				local prefix = icons[level:lower()]
				return prefix, "DiagnosticFloating" .. level
			end,
			format = function(d)
				return d.source and fmt("%s: %s", string.gsub(d.source, "%.$", ""), d.message) or d.message
			end,
			suffix = function(d)
				local code = d.code or (d.user_data and d.user_data.lsp.code)
				local suffix = code and fmt(" (%s)", code) or ""
				return suffix, "Comment"
			end,
		},
	})
end

return M
