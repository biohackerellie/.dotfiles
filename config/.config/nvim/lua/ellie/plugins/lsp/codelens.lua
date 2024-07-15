local M = {}

local augroup = require("ellie.util").augroup

--- @param client vim.lsp.Client
--- @param buffer number
function M.on_attach(client, buffer)
	if client.supports_method("textDocument/codeLens") then
		augroup(("LspCodeLens:%d"):format(buffer), {
			event = { "BufEnter", "CursorHold", "InsertLeave" },
			buffer = buffer,
			command = vim.lsp.codelens.refresh,
			desc = "Toggle codelens",
		})
	end
end

function M.refresh()
	local tsserver = vim.lsp.get_client_by_name("tsserver")
	local gopls = vim.lsp.get_client_by_name("gopls")
	if not tsserver or not gopls then
		return
	end
	vim.lsp.codelens.refresh({ bufnr = 0 })
end
return M
