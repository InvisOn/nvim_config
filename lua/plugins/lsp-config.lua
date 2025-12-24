return {
	{
		"mason-org/mason.nvim",
		opts = {},
	},

	{
		"williamboman/mason-lspconfig.nvim",
		opts = {},
		dependencies = {
			"mason-org/mason.nvim",
			"neovim/nvim-lspconfig",
		},
	},

	{
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = { "mason-org/mason.nvim" },
		opts = {
			ensure_installed = {
				-- Formatters & Tools
				"stylua",
				"tree-sitter-cli",
				-- LSP Servers
				"julia-lsp",
				"tinymist",
				"typescript-language-server",
			},
		},
	},

	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"mason-org/mason.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			-- Configure hover handler for better markdown rendering
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				border = "rounded",
				stylize_markdown = true,
			})

			-- Setup capabilities with cmp support
			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true
			capabilities.general.positionEncodings = { "utf-8", "utf-16" }

			-- Disable file watchers to prevent lag (especially for Python projects)
			capabilities.workspace = capabilities.workspace or {}
			capabilities.workspace.didChangeWatchedFiles = {
				dynamicRegistration = false,
			}

			local lspconfig = require("lspconfig")
			-- local lspconfig = vim.lsp.config()
			local lsp_flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 150,
			}

			-- C/C++
			vim.lsp.config.clangd = {
				capabilities = capabilities,
				flags = lsp_flags,
				cmd = { "clangd", "--offset-encoding=utf-16" },
			}

			-- Julia
			vim.lsp.config.julials = {
				capabilities = capabilities,
				flags = lsp_flags,
			}

			-- Python
			vim.lsp.config.pyright = {
				capabilities = capabilities,
				flags = lsp_flags,
				settings = {
					python = {
						typeCheckingMode = "strict",
						diagnosticMode = "workspace",
					},
					pyright = {
						disableLanguageServices = true,
					},
				},
			}

			-- Typst
			vim.lsp.config.tinymist = {
				capabilities = capabilities,
				flags = lsp_flags,
				settings = {
					exportPdf = "never",
					formatterMode = "typstyle",
				},
				on_attach = function()
					vim.lsp.buf_request_sync(0, "workspace/executeCommand", {
						command = "typst-lsp.doPinMain",
						arguments = {
							vim.uri_from_fname(vim.fn.getcwd() .. "/main.typ"),
						},
					}, 1000)
				end,
			}

			-- TypeScript/JavaScript
			vim.lsp.config.ts_ls = {
				capabilities = capabilities,
				flags = lsp_flags,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "js", "ojs" },
			}

			-- Global diagnostic keymaps
			vim.keymap.set("n", "<leader>le", vim.diagnostic.open_float, { desc = "Open diagnostic float" })
			vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
			vim.keymap.set("n", "<leader>lq", vim.diagnostic.setloclist, { desc = "Set loclist" })

			-- Buffer-local keymaps on LSP attach
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),
				callback = function(ev)
					-- Enable completion triggered by <c-x><c-o>
					vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

					local opts = { buffer = ev.buf }

					-- Navigation
					vim.keymap.set(
						"n",
						"gD",
						vim.lsp.buf.declaration,
						vim.tbl_extend("force", opts, { desc = "LSP go to declaration" })
					)
					vim.keymap.set(
						"n",
						"gd",
						require("telescope.builtin").lsp_definitions,
						vim.tbl_extend("force", opts, { desc = "LSP go to definition" })
					)
					vim.keymap.set(
						"n",
						"<leader>lD",
						vim.lsp.buf.type_definition,
						vim.tbl_extend("force", opts, { desc = "LSP go to type definition" })
					)

					-- Information
					vim.keymap.set(
						"n",
						"K",
						vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "LSP show hover" })
					)
					vim.keymap.set(
						"i",
						"<C-K>",
						vim.lsp.buf.hover,
						vim.tbl_extend("force", opts, { desc = "LSP show hover" })
					)

					-- Actions
					vim.keymap.set(
						{ "n", "v" },
						"<leader>lca",
						vim.lsp.buf.code_action,
						vim.tbl_extend("force", opts, { desc = "LSP code action" })
					)
					vim.keymap.set("n", "<leader>lf", function()
						vim.lsp.buf.format({ async = true })
					end, vim.tbl_extend("force", opts, { desc = "LSP format" }))
				end,
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
