local M = {}

M._keys = nil

function M.get()
  if not M._keys then
    -- stylua: ignore
    M._keys = {
      { "gd", "<CMD>Telescope lsp_definitions<CR>", desc = "Goto Definition", deps = "textDocument/definition" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration", deps = "textDocument/declaration" },
      { "gr", "<CMD>Telescope lsp_references<CR>", desc = "References", deps = "textDocument/references" },
      { "gi", "<CMD>Telescope lsp_implementations<CR>", desc = "Goto Implementation", deps = "textDocument/implementation" },
      { "gt", "<CMD>Telescope lsp_type_definitions<CR>", desc = "Goto Type Definition", deps = "textDocument/definition" },
      { "K", require("hover").hover, desc = "Hover" },
      { "gK", require("hover").hover_select, desc = "hover.nvim (select)" },
      { "<C-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help", deps = "textDocument/signatureHelp" },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename", deps = "textDocument/rename"  },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code action", mode = { "n", "v" }, deps = "textDocument/codeAction" },
      { "<MouseMove>", require("hover").hover_mouse, desc = "hover.nvim (mouse)" },
    }
  end
  return M._keys
end

---@param client vim.lsp.Client
---@param buffer number
function M.on_attach(client, buffer)
  vim.iter(M.get()):each(function(m)
    if not m.deps or client.supports_method(m.deps) then
      local opts = { silent = true, buffer = buffer, desc = m.desc }
      vim.keymap.set(m.mode or "n", m[1], m[2], opts)
			vim.o.mousemoveevent = true
    end
  end)

-- If the filetype is Rust, override with rustaceanvim keybindings
  if vim.bo[buffer].filetype == "rust" then
    local opts = { silent = true, buffer = buffer }
    vim.keymap.set("n", "<leader>ca",
      function() vim.cmd.RustLsp('codeAction') end,
      vim.tbl_extend("force", opts, { desc = "Rust Code Action" })
    )
    vim.keymap.set("n", "K",
      function() vim.cmd.RustLsp({ "hover", "actions" }) end,
      vim.tbl_extend("force", opts, { desc = "Rust Hover Actions" })
    )
  end
end


return M
