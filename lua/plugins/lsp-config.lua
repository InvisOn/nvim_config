return {
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup({})
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "clangd",
          "ts_ls",
          "julials",
          "lua_ls",
          "nim_langserver",
          "sqlls",
          "zls",
        },
        automatic_installation = true,
      })
    end,
  },

  {
    "neovim/nvim-lspconfig", -- TODO: :LspInfo float is default behaviour. So, I must have disabled it somewhere.
    dependencies = {
      { "williamboman/mason.nvim" },
      { "WhoIsSethDaniel/mason-tool-installer.nvim" },
      { "folke/neodev.nvim",                        opts = {}, enabled = true },
    },
    config = function()
      vim.lsp.set_log_level("debug")
      require("mason-tool-installer").setup({
        ensure_installed = {
          "stylua",
          "shfmt",
          "tree-sitter-cli",
          "pyright",
        },
      })

      local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

      local lspconfig = require("lspconfig")

      local lsp_flags = {
        allow_incremental_sync = true,
        debounce_text_changes = 150,
      }

      lspconfig.clangd.setup({
        capabilities = default_capabilities,
        cmd = { "clangd", "--offset-encoding=utf-16" },
        lsp_flags = lsp_flags,
      })

      lspconfig.julials.setup({ capabilities = default_capabilities, flags = lsp_flags })
      lspconfig.pylsp.setup({ capabilities = default_capabilities })
      lspconfig.nim_langserver.setup({ capabilities = default_capabilities })
      lspconfig.ruff.setup({ capabilities = default_capabilities })
      lspconfig.sqlls.setup({ capabilities = default_capabilities })
      lspconfig.zls.setup({ capabilities = default_capabilities })
      lspconfig.tinymist.setup({
        capabilities = default_capabilities,
        settings = { exportPdf = "never", formatterMode = "typstyle" },
        on_attach = function()
          vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
            command = "typst-lsp.doPinMain",
            arguments = {
              vim.uri_from_fname(vim.fn.getcwd() .. "/main.typ"),
            },
          }, 1000)
        end,
      })

      -- local ocaml_capabilities = require("cmp_nvim_lsp").default_capabilities()
      -- lspconfig.ocamllsp.setup({
      -- 	cmd = { "ocamllsp" },
      -- 	filetypes = {
      -- 		"ocaml",
      -- 		"ocaml.menhir",
      -- 		"ocaml.interface",
      -- 		"ocaml.ocamllex",
      -- 		"reason",
      -- 		"dune",
      -- 	},
      -- 	root_dir = lspconfig.util.root_pattern(
      -- 		"*.opam",
      -- 		"esy.json",
      -- 		"package.json",
      -- 		".git",
      -- 		"dune-project",
      -- 		"dune-workspace",
      -- 		".merlin",
      -- 		"*.ml"
      -- 	),
      -- 	capabilities = ocaml_capabilities,
      -- })

      local util = require("lspconfig.util")

      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- lspconfig.r_language_server.setup({
      --   capabilities = capabilities,
      --   flags = lsp_flags,
      --   settings = {
      --     r = {
      --       lsp = {
      --         rich_documentation = false,
      --       },
      --     },
      --   },
      -- })

      lspconfig.cssls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.html.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.yamlls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          yaml = {
            schemaStore = {
              enable = true,
              url = "",
            },
          },
        },
      })

      lspconfig.dotls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
      })

      lspconfig.ts_ls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { "js", "javascript", "typescript", "ojs", "typescriptreact" },
      })

      local lua_library_files = vim.api.nvim_get_runtime_file("", true)
      local lua_plugin_paths = {}

      lspconfig.lua_ls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          Lua = {
            completion = {
              callSnippet = "Replace",
            },
            runtime = {
              version = "LuaJIT",
              plugin = lua_plugin_paths,
            },
            diagnostics = {
              globals = { "vim", "quarto", "pandoc", "io", "string", "print", "require", "table" },
              disable = { "trailing-space" },
            },
            workspace = {
              library = lua_library_files,
              checkThirdParty = false,
            },
            telemetry = {
              enable = false,
            },
          },
        },
      })

      lspconfig.bashls.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        filetypes = { "sh", "bash" },
      })

      -- See https://github.com/neovim/neovim/issues/23291
      -- disable lsp watcher.
      -- Too lags on linux for python projects
      -- because pyright and nvim both create too many watchers otherwise
      if capabilities.workspace == nil then
        capabilities.workspace = {}
        capabilities.workspace.didChangeWatchedFiles = {}
      end
      capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

      lspconfig.pyright.setup({
        capabilities = capabilities,
        flags = lsp_flags,
        settings = {
          pyright = { disableLanguageServices = true },
          python = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace",
            },
          },
        },
        root_dir = function(fname)
          return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt", "*")(
            fname
          ) or util.fs.dirname(fname)
        end,
      })

      -- Global mappings. https://github.com/neovim/nvim-lspconfig#suggested-configuration
      -- See `:help vim.diagnostic.*` for documentation on any of the below functions
      vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
      vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
      vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set loclist" })

      -- Use LspAttach autocommand to only map the following keymap
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd("LspAttach", {
        group = vim.api.nvim_create_augroup("UserLspConfig", {}),
        callback = function(ev) -- Enable completion triggered by <c-x><c-o>
          vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

          -- Buffer local mappings.
          -- -- See `:help vim.lsp.*` for documentation on any of the below functions
          vim.keymap.set(
            "n",
            "gD",
            vim.lsp.buf.declaration,
            { buffer = ev.buf, desc = "LSP go to declaration" }
          )
          vim.keymap.set(
            "n",
            "gd",
            vim.lsp.buf.definition,
            { buffer = ev.buf, desc = "LSP go to definition" }
          )
          vim.keymap.set("n", "K", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP show hover" })
          vim.keymap.set("i", "<C-K>", vim.lsp.buf.hover, { buffer = ev.buf, desc = "LSP show hover" })
          vim.keymap.set(
            "n",
            "gi",
            vim.lsp.buf.implementation,
            { buffer = ev.buf, desc = "LSP go to implementation" }
          )
          vim.keymap.set(
            "n",
            "<leader>n",
            vim.lsp.buf.signature_help,
            { buffer = ev.buf, desc = "LSP show signature help" }
          )
          vim.keymap.set(
            "n",
            "<leader>lwa",
            vim.lsp.buf.add_workspace_folder,
            { buffer = ev.buf, desc = "LSP add workspace folder" }
          )
          vim.keymap.set(
            "n",
            "<leader>lwr",
            vim.lsp.buf.remove_workspace_folder,
            { buffer = ev.buf, desc = "LSP remove workspace folder" }
          )
          vim.keymap.set("n", "<leader>lwl", function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { buffer = ev.buf, desc = "LSP list workspace folders" })
          vim.keymap.set(
            "n",
            "<leader>lD",
            vim.lsp.buf.type_definition,
            { buffer = ev.buf, desc = "LSP go to type definition" }
          )
          -- vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
          vim.keymap.set(
            { "n", "v" },
            "<leader>lca",
            vim.lsp.buf.code_action,
            { buffer = ev.buf, desc = "LSP code action" }
          )
          -- vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
          vim.keymap.set("n", "<leader>lf", function()
            vim.lsp.buf.format({ async = true })
          end, { buffer = ev.buf, desc = "LSP format" })
        end,
      })
    end,
  },

  {
    "nvimtools/none-ls.nvim",
    config = function()
      local null_ls = require("null-ls")

      null_ls.setup({})
    end,
  },

  {
    "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
    config = function()
      require("lsp_lines").setup()
      vim.diagnostic.config({ virtual_lines = false })
      vim.keymap.set("", "<Leader>ll", require("lsp_lines").toggle, { desc = "Toggle lsp_lines" })
    end,
  },
}
