local M = {}

M._keys = nil

function M.get()
	if not M._keys then
    -- stylua: ignore
    M._keys = {
    }
	end
	return M._keys
end

---@param buffer integer
function M.on_attach(buffer)
	vim.iter(M.get()):each(function(m)
		local opts = { silent = true, buffer = buffer, desc = m.desc }
		vim.keymap.set(m.mode or "n", m[1], m[2], opts)
		vim.o.mousemoveevent = true
	end)

	-- If the filetype is Rust, override with rustaceanvim keybindings
	if vim.bo[buffer].filetype == "rust" then
		local opts = { silent = true, buffer = buffer }
		vim.keymap.set("n", "<leader>ca", function()
			vim.cmd.RustLsp("codeAction")
		end, vim.tbl_extend("force", opts, { desc = "Rust Code Action" }))
		vim.keymap.set("n", "K", function()
			vim.cmd.RustLsp({ "hover", "actions" })
		end, vim.tbl_extend("force", opts, { desc = "Rust Hover Actions" }))
	end
end

return M
