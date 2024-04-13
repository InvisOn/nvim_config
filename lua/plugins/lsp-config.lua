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
					"biome",
					"clangd",
					"jdtls",
					"julials",
					"kotlin_language_server",
					"lua_ls",
					"marksman",
					"nim_langserver",
					"ruff_lsp",
					"rust_analyzer",
					"sqlls",
					"zls",
				},
			})
		end,
		opts = { biome = {} },
	},
	{
		"neovim/nvim-lspconfig",
		config = function() -- use `:h vim.lsp.buf` for setup options
			local capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")
			lspconfig.biome.setup({ capabilities = capabilities })
			lspconfig.gopls.setup({ capabilities = capabilities })
			lspconfig.clangd.setup({ capabilities = capabilities })
			lspconfig.jdtls.setup({ capabilities = capabilities })
			lspconfig.julials.setup({ capabilities = capabilities })
			lspconfig.kotlin_language_server.setup({ capabilities = capabilities })
			lspconfig.lua_ls.setup({ capabilities = capabilities })
			lspconfig.marksman.setup({ capabilities = capabilities })
			lspconfig.nim_langserver.setup({ capabilities = capabilities })
			lspconfig.ruff_lsp.setup({ capabilities = capabilities })
			lspconfig.pyright.setup({ capabilities = capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = capabilities })
			lspconfig.sqlls.setup({ capabilities = capabilities })
			lspconfig.zls.setup({ capabilities = capabilities })

			-- Global mappings. https://github.com/neovim/nvim-lspconfig#suggested-configuration
			-- See `:help vim.diagnostic.*` for documentation on any of the below functions
			vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float)
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
			vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist)

			-- Use LspAttach autocommand to only map the following keymap
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev) -- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Buffer local mappings.
					-- -- See `:help vim.lsp.*` for documentation on any of the below functions
					local opts = { buffer = ev.buf }
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					vim.keymap.set("n", "<leader>k", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "<leader>lwa", vim.lsp.buf.add_workspace_folder, opts)
					vim.keymap.set("n", "<leader>lwr", vim.lsp.buf.remove_workspace_folder, opts)
					vim.keymap.set("n", "<leader>lwl", function()
						print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
					end, opts)
					vim.keymap.set("n", "<leader>lD", vim.lsp.buf.type_definition, opts)
					vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, opts)
					vim.keymap.set({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, opts)
				end,
			})
		end,
	},
	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				sources = {
					-- null_ls.builtins.completion.spell,
					-- null_ls.builtins.diagnostics.biome,
					-- null_ls.builtins.formatting.prettier,
					null_ls.builtins.formatting.stylua,
					null_ls.builtins.formatting.biome.with({
						args = {
							"check",
							"--apply-unsafe",
							"--formatter-enabled=true",
							"--organize-imports-enabled=true",
							"--skip-errors",
							"$FILENAME",
						},
					}),
				},
			})
		end,
	},
}
