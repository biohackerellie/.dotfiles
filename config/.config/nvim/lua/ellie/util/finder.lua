---@class ellie.util.finder
local E = {}

E.symbols = {
  defualt = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
  lua = {
    "Enum",
    "Function",
    "Interface",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "Trait",
  },
  go = {
    "Interface",
    "Struct",
    "Function",
    "Method",
  },
  typescript = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "TypeParameter",
    "Variable",
  },
  typescriptreact = {
    "Class",
    "Constructor",
    "Enum",
    "Field",
    "Function",
    "Interface",
    "Method",
    "Module",
    "Namespace",
    "Property",
    "Struct",
    "TypeParameter",
    "Variable",
  },
  markdown = false,
}

---@param buf? number
---@return string[]?
function E.get_symbols(buf)
  buf = (buf == nil or buf == 0) and vim.api.nvim_get_current_buf() or buf
  local ft = vim.bo[buf].filetype
  if E.symbols[ft] == false then
    return
  end
  return E.symbols[ft] or E.symbols.defualt
end

---https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#symbolKind
---@param scope "workspace" | "document"
function E.lsp_symbols(scope)
  return function()
    local symbols = E.get_symbols()
    if symbols then
      local sc = vim.deepcopy(symbols)
      table.insert(sc, 1, "All")
      vim.ui.select(sc, { prompt = "Select which symbol(" .. scope .. ")" }, function(item)
        if item then
          local items = item == "All" and symbols or { item }
          if scope == "workspace" then
            require("telescope.builtin").lsp_workspace_symbols({ symbols = items })
          else
            require("telescope.builtin").lsp_document_symbols({ symbols = items })
          end
        end
      end)
    end
  end
end

function E.config_files()
  return function()
    require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
  end
end

return E