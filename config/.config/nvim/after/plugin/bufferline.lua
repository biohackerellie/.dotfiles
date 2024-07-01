-- Σ(💩)local bufferline = require('bufferline')
-- local mocha = require('catppuccin.palettes').get_palette  "mocha"
-- bufferline.setup {
--   options = {
-- 	  themable = true,
--
-- highlights = require('catppuccin.groups.integrations.bufferline').get {
--         custom = {
--           all = {
--             indicator_selected = { fg = mocha.lavender, style = {} },
--             indicator_visible = { fg = mocha.mantle, bg = mocha.mantle },
--
--             buffer_selected = { fg = mocha.lavender, style = {} }, -- current
--
--             modified = { fg = mocha.lavender },
--             modified_visible = { fg = mocha.lavender },
--             modified_selected = { fg = mocha.lavender },
--           },
--         },
--       },
--
--     offsets = {{filetype = "NvimTree", separator = false,}},
--
--   }
-- }

vim.g.barbar_auto_setup = false
require('barbar').setup {
	animation = true,
	auto_hide = 0,
	clickable = true,
	hide = {extensions = true},
	sidebar_filetypes = {
		NvimTree = true,
	}

}
