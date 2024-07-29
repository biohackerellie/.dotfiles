-- local M = {}

-- local augroup = require("ellie.util").augroup

-- --- @param client vim.lsp.Client
-- --- @param buffer number
-- function M.on_attach(client, buffer)
-- 	if client.supports_method("textDocument/codeLens") then
-- 		augroup(("LspCodeLens:%d"):format(buffer), {
-- 			event = { "BufEnter", "CursorHold", "InsertLeave" },
-- 			buffer = buffer,
-- 			command = vim.lsp.codelens.refresh,
-- 			desc = "Toggle codelens",
-- 		})
-- 	else
-- 		return
-- 	end
-- end

-- return M
