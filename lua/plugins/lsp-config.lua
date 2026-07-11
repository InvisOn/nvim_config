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
			-- automatic_enable = true (default) calls vim.lsp.enable() for all
			-- mason-installed servers. Keep false only if you want manual control.
			require("mason-lspconfig").setup({
				automatic_enable = true,
			})
		end,
	},

	{
		"neovim/nvim-lspconfig", -- still needed: populates lsp/ runtime configs
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
		},
		config = function()
			-- vim.lsp.set_log_level("debug")
			require("mason-tool-installer").setup({
				ensure_installed = {
					"lua_ls",
					"stylua",
					-- "pyright",
					"tree-sitter-cli",
				},
			})

			-- Global defaults: applied to every server via the '*' wildcard.
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- See https://github.com/neovim/neovim/issues/23291
			-- Disable LSP file watcher; too laggy on Linux for Python projects.
			if capabilities.workspace == nil then
				capabilities.workspace = {}
				capabilities.workspace.didChangeWatchedFiles = {}
			end
			capabilities.workspace.didChangeWatchedFiles.dynamicRegistration = false

			vim.lsp.config("*", { capabilities = capabilities })

			-- Per-server overrides.
			vim.lsp.config("pylsp", {
				settings = {
					pylsp = {
						plugins = {
							pycodestyle = {
								enabled = true,
								ignore = { "E501" },
								maxLineLength = 200,
							},
							-- pyflakes = { enabled = false },
							-- pylint   = { enabled = false },
							-- flake8   = { enabled = false },
							-- mccabe   = { enabled = false },
						},
					},
				},
			})

			vim.lsp.config("clangd", {
				cmd = { "clangd", "--offset-encoding=utf-16" },
			})

			-- If automatic_enable = false above, enable servers explicitly:
			-- vim.lsp.enable({ "pylsp", "clangd", "lua_ls" })

			-- Diagnostic keymaps
			vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
			vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set loclist" })

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local map = function(mode, lhs, rhs, desc)
						vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc })
					end

					map("n", "gD", vim.lsp.buf.declaration, "LSP go to declaration")
					-- map("n", "gd", vim.lsp.buf.definition, "LSP go to definition")

					map("n", "K", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "LSP show hover")

					map("i", "<C-K>", function()
						vim.lsp.buf.hover({ border = "rounded" })
					end, "LSP show hover")

					map("n", "<leader>n", function()
						vim.lsp.buf.signature_help({ border = "rounded" })
					end, "LSP show signature help")

					map("n", "gi", vim.lsp.buf.implementation, "LSP go to implementation")
					map("n", "<leader>lD", vim.lsp.buf.type_definition, "LSP go to type definition")
					map({ "n", "v" }, "<leader>lca", vim.lsp.buf.code_action, "LSP code action")
					map("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, "LSP format")
				end,
			})
		end,
	},

	{
		"nvimtools/none-ls.nvim",
		config = function()
			local null_ls = require("null-ls")
			null_ls.setup({
				-- sources = { null_ls.builtins.formatting.black },
			})
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
