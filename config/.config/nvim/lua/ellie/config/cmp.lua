local cmp = require("cmp")

local cmp_ui = {
	icons = true,
	lspkind_text = true,
	style = "default", -- default/flat_light/flat_dark/atom/atom_colored
	border_color = "grey_fg", -- only applicable for "default" style, use color names from base30 variables
	selected_item_bg = "simple", -- colored / simple
}
local cmp_style = cmp_ui.style

local border = require("ellie.config").get_border()

local options = {
	completion = {
		completeopt = "menu,menuone",
	},

	window = {
		completion = {
			border = border,
			winhighlight = "Normal:Pmenu,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
		},
		documentation = {
			border = border,
			winhighlight = "Normal:NormalFloat,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
		},
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	formatting = {
		expandable_indicator = false,
		fields = { "kind", "abbr", "menu" },
		format = function(entry, item)
			local icons = require("ellie.config").icons.kinds
			if icons[item.kind] then
				item.kind = icons[item.kind] .. item.kind
			end
			-- if entry.source.name ~= "copilot" then
			-- 	local widths = { abbr = 27, menu = 35 }
			-- 	for key, value in pairs(widths) do
			-- 		if item[key] and vim.fn.strchars(item[key]) > value then
			-- 			item[key] = vim.fn.strcharpart(item[key], 0, value - 3) .. "..."
			-- 		end
			-- 	end
			-- end
			return item
		end,
	},

	--formatting = formatting_style,

	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			-- local copilot = require("copilot.suggesion")
			-- if copilot.is_visible() then
			-- 	copilot.accept()
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
	sources = {
		{ name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "buffer" },
		{ name = "nvim_lua" },
		{ name = "path" },
		{ name = "crates" },
		-- { name = "copilot" },
	},
}

if cmp_style ~= "atom" and cmp_style ~= "atom_colored" then
	options.window.completion.border = border("CmpBorder")
end

return {
	sources = {
		{ name = "nvim_lsp" },
		{ name = "buffer" },
		{ name = "path" },
		{ name = "luasnip" },
		{ name = "nvim_lua" },
		-- { name = "copilot" },
	},
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item(),
		["<C-n>"] = cmp.mapping.select_next_item(),
		["<C-d>"] = cmp.mapping.scroll_docs(-4),
		["<C-f>"] = cmp.mapping.scroll_docs(4),
		["<C-Space>"] = cmp.mapping.complete(),
		["<C-e>"] = cmp.mapping.close(),
		["<CR>"] = cmp.mapping.confirm({
			behavior = cmp.ConfirmBehavior.Insert,
			select = true,
		}),
		["<Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_next_item()
			elseif require("luasnip").expand_or_jumpable() then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-expand-or-jump", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
		["<S-Tab>"] = cmp.mapping(function(fallback)
			if cmp.visible() then
				cmp.select_prev_item()
			elseif require("luasnip").jumpable(-1) then
				vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
			else
				fallback()
			end
		end, {
			"i",
			"s",
		}),
	},
}
