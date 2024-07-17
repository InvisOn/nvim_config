return {
	{
		"williamboman/mason.nvim",
		config = function()
			require("mason").setup({})
		end,
	},

	-- {
	-- 	-- for lsp features in code cells / embedded code
	-- 	"jmbuhr/otter.nvim",
	-- 	lazy = false,
	-- 	dev = false,
	-- 	dependencies = {
	-- 		{
	-- 			"neovim/nvim-lspconfig",
	-- 			"nvim-treesitter/nvim-treesitter",
	-- 			"hrsh7th/nvim-cmp",
	-- 		},
	-- 	},
	-- 	opts = {
	-- 		lsp = {
	-- 			hover = {
	-- 				border = require("misc.style").border,
	-- 			},
	-- 		},
	-- 		buffers = {
	-- 			set_filetype = true,
	-- 			write_to_disk = false,
	-- 		},
	-- 		handle_leading_whitespace = true,
	-- 	},
	-- },

	{
		"williamboman/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"biome",
					"ltex",
					"clangd",
					"jdtls",
					"r_language_server",
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
		dependencies = {
			{ "williamboman/mason.nvim" },
			{ "WhoIsSethDaniel/mason-tool-installer.nvim" },
			{ "folke/neodev.nvim", opts = {}, enabled = true },
		},
		config = function() -- use `:h vim.lsp.buf` for setup options
			require("mason-tool-installer").setup({
				ensure_installed = {
					"black",
					"stylua",
					"shfmt",
					"isort",
					"tree-sitter-cli",
					"jupytext",
				},
			})

			local default_capabilities = require("cmp_nvim_lsp").default_capabilities()

			local lspconfig = require("lspconfig")

			local lsp_flags = {
				allow_incremental_sync = true,
				debounce_text_changes = 150,
			}

			lspconfig.biome.setup({ capabilities = default_capabilities })
			lspconfig.ltex.setup({ capabilities = default_capabilities })
			lspconfig.gopls.setup({ capabilities = default_capabilities })
			lspconfig.clangd.setup({
				capabilities = default_capabilities,
				cmd = { "clangd", "--offset-encoding=utf-16" },
				lsp_flags = lsp_flags,
			})
			lspconfig.jdtls.setup({ capabilities = default_capabilities })
			lspconfig.julials.setup({ capabilities = default_capabilities })
			lspconfig.kotlin_language_server.setup({ capabilities = default_capabilities })
			lspconfig.lua_ls.setup({ capabilities = default_capabilities })
			lspconfig.marksman.setup({ capabilities = default_capabilities })
			lspconfig.nim_langserver.setup({ capabilities = default_capabilities })
			lspconfig.ruff_lsp.setup({ capabilities = default_capabilities })
			lspconfig.pyright.setup({ capabilities = default_capabilities })
			lspconfig.rust_analyzer.setup({ capabilities = default_capabilities })
			lspconfig.sqlls.setup({ capabilities = default_capabilities })
			lspconfig.zls.setup({ capabilities = default_capabilities })
			lspconfig.gleam.setup({ capabilities = default_capabilities })

			local ocaml_capabilities = require("cmp_nvim_lsp").update_capabilities()

			lspconfig.ocamllsp.setup({
				cmd = { "ocamllsp" },
				filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
				root_dir = lspconfig.util.root_pattern(
					"*.opam",
					"esy.json",
					"package.json",
					".git",
					"dune-project",
					"dune-workspace"
				),
				capabilities = ocaml_capabilities,
			})
			-- for quarto start
			local util = require("lspconfig.util")
			vim.lsp.handlers["textDocument/hover"] =
				vim.lsp.with(vim.lsp.handlers.hover, { border = require("misc.style").border })
			vim.lsp.handlers["textDocument/signatureHelp"] =
				vim.lsp.with(vim.lsp.handlers.signature_help, { border = require("misc.style").border })

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())
			capabilities.textDocument.completion.completionItem.snippetSupport = true

			-- also needs:
			-- $home/.config/marksman/config.toml :
			-- [core]
			-- markdown.file_extensions = ["md", "markdown", "qmd"]
			lspconfig.marksman.setup({
				capabilities = capabilities,
				filetypes = { "markdown", "quarto" },
				root_dir = util.root_pattern(".git", ".marksman.toml", "_quarto.yml"),
			})

			lspconfig.r_language_server.setup({
				capabilities = capabilities,
				flags = lsp_flags,
				settings = {
					r = {
						lsp = {
							rich_documentation = false,
						},
					},
				},
			})

			lspconfig.cssls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.html.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.emmet_language_server.setup({
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

			lspconfig.tsserver.setup({
				capabilities = capabilities,
				flags = lsp_flags,
				filetypes = { "js", "javascript", "typescript", "ojs" },
			})

			local function get_quarto_resource_path()
				local function strsplit(s, delimiter)
					local result = {}
					for match in (s .. delimiter):gmatch("(.-)" .. delimiter) do
						table.insert(result, match)
					end
					return result
				end

				local f = assert(io.popen("quarto --paths", "r"))
				local s = assert(f:read("*a"))
				f:close()
				return strsplit(s, "\n")[2]
			end

			local lua_library_files = vim.api.nvim_get_runtime_file("", true)
			local lua_plugin_paths = {}
			local resource_path = get_quarto_resource_path()
			if resource_path == nil then
				vim.notify_once("quarto not found, lua library files not loaded")
			else
				table.insert(lua_library_files, resource_path .. "/lua-types")
				table.insert(lua_plugin_paths, resource_path .. "/lua-plugin/plugin.lua")
			end

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

			lspconfig.julials.setup({
				capabilities = capabilities,
				flags = lsp_flags,
			})

			lspconfig.bashls.setup({
				capabilities = capabilities,
				flags = lsp_flags,
				filetypes = { "sh", "bash" },
			})

			-- Add additional languages here.
			-- See `:h lspconfig-all` for the configuration.
			-- Like e.g. Haskell:
			-- lspconfig.hls.setup {
			--   capabilities = capabilities,
			--   flags = lsp_flags
			-- }

			-- lspconfig.rust_analyzer.setup{
			--   capabilities = capabilities,
			--   settings = {
			--     ['rust-analyzer'] = {
			--       diagnostics = {
			--         enable = false;
			--       }
			--     }
			--   }
			-- }

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
					python = {
						analysis = {
							autoSearchPaths = true,
							useLibraryCodeForTypes = true,
							diagnosticMode = "workspace",
						},
					},
				},
				root_dir = function(fname)
					return util.root_pattern(".git", "setup.py", "setup.cfg", "pyproject.toml", "requirements.txt")(
						fname
					) or util.path.dirname(fname)
				end,
			})
			-- for quarto end

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
					vim.keymap.set(
						"n",
						"gi",
						vim.lsp.buf.implementation,
						{ buffer = ev.buf, desc = "LSP go to implementation" }
					)
					vim.keymap.set(
						"n",
						"<leader>k",
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
					vim.keymap.set("n", "<leader>lrn", vim.lsp.buf.rename, { buffer = ev.buf, desc = "Rename" })
					vim.keymap.set(
						{ "n", "v" },
						"<leader>lca",
						vim.lsp.buf.code_action,
						{ buffer = ev.buf, desc = "LSP code action" }
					)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = ev.buf, desc = "Go to references" })
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
			null_ls.setup({
				-- on_init = function(new_client, _)
				--     new_client.offset_encoding = "utf-32"
				-- end,
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
