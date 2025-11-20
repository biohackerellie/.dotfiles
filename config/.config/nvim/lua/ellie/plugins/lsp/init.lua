local M = {
  {
    "neovim/nvim-lspconfig",
    lazy = false,
    config = function(_, opts)
      local lspconfig = vim.lsp.config
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      local U = require("ellie.util").lsp
      local Util = require("ellie.util")
      require("ellie.plugins.lsp.diagnostic").setup()
      require("lspconfig.ui.windows").default_options.border = require("ellie.config").get_border()

      local on_attach = U.on_attach(function(client, buffer)
        require("ellie.plugins.lsp.keymaps").on_attach(client, buffer)
        require("ellie.plugins.lsp.codelens").on_attach(client, buffer)
        require("ellie.plugins.lsp.highlight").on_attach(client, buffer)
        if client.name == "biome" then
          Util.augroup("BiomeFixAll", {
            clear = true,
            event = "BufWritePre",
            command = function()
              vim.lsp.buf.code_action({
                context = {
                  only = { "source.fixAll.biome" },
                  diagnostics = {},
                },
                apply = true
              })
            end
          })
        end
      end)

      local lsp_flags = {
        debounce_text_changes = 150,
      }
      -- require("typescript-tools").setup({
      -- 	on_attach = on_attach,
      -- })

      -- Servers {{{
      -- Lua {{{
      lspconfig.lua_ls = {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = lsp_flags,
        cmd = { "lua-language-server" },
        filetypes = { "lua" },
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
              disable = { "different-requires" },
            },
          },
        },
      }
      vim.lsp.enable('lua_ls')
      -- }}}

      -- GdScript {{{
      lspconfig.gdscript = {
        on_attach = on_attach,
        capabilities,
        flags = lsp_flags,
        cmd = vim.lsp.rpc.connect("127.0.0.1", 6005),
        filetypes = { "gd", "gdscript", "gdscript3" },
      }
      vim.lsp.enable('gdscript')
      -- }}}

      -- Rust {{{
      lspconfig.rust_analyzer = {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "rust-analyzer" },
        filetypes = { "rust", "rs" },
        diagnostics = {
          refreshSupport = false,
        },
        procMacro = {
          enable = true,
        },
      }
      vim.lsp.enable('rust_analyzer')
      -- }}}

      -- Typescript {{{
      lspconfig.vtsls = {
        on_attach = on_attach,
        capabilities = capabilities,
        cmd = { "vtsls", "--stdio" },
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
      }
      vim.lsp.enable('vtsls')
      -- }}}

      -- Vim {{{
      lspconfig.vimls = {
        filetypes = { "vim" },
        cmd = { "vim-language-server", "--stdio" },
        on_attach = on_attach,
      }
      vim.lsp.enable('vimls')
      -- }}}

      -- Go {{{
      lspconfig.gopls = {
        filetypes = { "go", "gomod", "gowork", "gotmpl" },
        cmd = { "gopls" },
        settings = {
          env = {
            GOEXPERIMENT = "rangefunc",
            GOFLAGS = "-tags=postgres",
          },
          on_attach = on_attach,
          capabilities = capabilities,
          usePlaceholders = false,
          ["local"] = "<repo>",
          formatting = {
            gofumpt = true,
          },
        },
      }
      vim.lsp.enable('gopls')
      -- }}}

      -- HTML {{{
      lspconfig.templ = {
        on_attach = on_attach,
      }
      vim.lsp.enable('templ')
      -- }}}
      lspconfig.svelte = {
        filetypes = { "svelte" },
        on_attach = on_attach,
      }
      vim.lsp.enable('svelte')
      -- }}}
      lspconfig.jsonls = {
        on_attach = on_attach,
      }
      vim.lsp.enable('jsonls')
      lspconfig.biome = {
        on_attach = on_attach,
        capabilities = capabilities,
      }
      vim.lsp.enable('biome')

      lspconfig.zls = {
        on_attach = on_attach
      }
      vim.lsp.enable('zls')
      lspconfig.tailwindcss = {
        on_attach = on_attach,
        filetypes = {
          -- html
          "aspnetcorerazor",
          "astro",
          "astro-markdown",
          "blade",
          "clojure",
          "django-html",
          "htmldjango",
          "edge",
          "eelixir", -- vim ft
          "elixir",
          "ejs",
          "erb",
          "eruby", -- vim ft
          "gohtml",
          "gohtmltmpl",
          "haml",
          "handlebars",
          "hbs",
          "html",
          "htmlangular",
          "html-eex",
          "heex",
          "jade",
          "leaf",
          "liquid",
          "markdown",
          "mdx",
          "mustache",
          "njk",
          "nunjucks",
          "php",
          "razor",
          "slim",
          "twig",
          -- css
          "css",
          "less",
          "postcss",
          "sass",
          "scss",
          "stylus",
          "sugarss",
          -- js
          "javascript",
          "javascriptreact",
          "reason",
          "rescript",
          "typescript",
          "typescriptreact",
          -- mixed
          "vue",
          "svelte",
          "templ",
        },
        settings = {

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
          tailwindCSS = {
            includeLanguages = {
              templ = "html",
            },
          },
        },
      }
      vim.lsp.enable('tailwindcss')

      -- }}}
    end,
  },
  -- {
  -- 	"pmizio/typescript-tools.nvim",
  -- 	dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
  -- 	opts = {},
  -- },
  {
    "yioneko/nvim-vtsls",
    ft = {
      "javascript",
      "javascriptreact",
      "typescript",
      "typescriptreact",
    },
    dependencies = { "nvim-lspconfig" },
  },
  { "habamax/vim-godot", event = "BufEnter *.gd" },
}

return M
