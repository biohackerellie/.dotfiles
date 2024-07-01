local lualine = require('lualine')

local mode_map = {
   n = "(ᴗ_ ᴗ。)",
   nt = "(ᴗ_ ᴗ。)",
   i = "(•̀ - •́ )",
   R = "( •̯́ ₃ •̯̀)",
   v = "(⊙ _ ⊙ )",
   V = "(⊙ _ ⊙ )",
   no = "Σ(°△°ꪱꪱꪱ)",
   ["\22"] = "(⊙ _ ⊙ )",
   t = "(⌐■_■)",
   ['!'] = "Σ(💩)",
   c = "(⊙_⊙)⊃━☆ﾟ.*",
   s = "SUB"
}


lualine.setup({
	options = {
		theme = 'catppuccin',
		icons_enabled = true,
		 component_separators = { left = '', right = ''},
    section_separators = { left = '', right = ''},
    disabled_filetypes = {
      statusline = {},
      winbar = {},
    },
    ignore_focus = {},
    always_divide_middle = true,
    globalstatus = true,
    refresh = {
      statusline = 1000,
      tabline = 1000,
      winbar = 1000,
    }
  },
  sections = {
    lualine_a = {{'mode',
			            fmt = function()
               return mode_map[vim.api.nvim_get_mode().mode] or vim.api.nvim_get_mode().mode
            end
		}
		},
    lualine_b = {'branch', 'diff', 'diagnostics'},
    lualine_c = {'filename'},
    lualine_x = {'encoding', 'fileformat', 'filetype'},
    lualine_y = {'progress'},
    lualine_z = {'location'}
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {'filename'},
    lualine_x = {'location'},
    lualine_y = {},
    lualine_z = {}
  },
  tabline = {},
  winbar = {},
  inactive_winbar = {},
  extensions = {},

})
