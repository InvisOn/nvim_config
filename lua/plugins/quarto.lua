return {
	{
		-- requires plugins in lua/plugins/treesitter.lua and lua/plugins/lsp.lua
		-- for complete functionality (language features)
		"quarto-dev/quarto-nvim",
		-- FIX [Quarto] couldn't find appropriate code runner for language: r
		-- FIX [Quarto] couldn't find appropriate code runner for language: julia
		-- FIX [Quarto] couldn't find appropriate code runner for language: python
		ft = { "quarto" },
		dev = false,
		opts = {
			lspFeatures = {
				languages = { "r", "python", "julia", "bash", "lua", "html", "dot", "javascript", "typescript", "ojs" },
			},
			codeRunner = {
				enabled = true,
				default_method = "slime",
			},
		},
		dependencies = {
			-- for language features in code cells
			-- configured in lua/plugins/lsp.lua and
			-- added as a nvim-cmp source in lua/plugins/completion.lua
			"jmbuhr/otter.nvim",
		},
		config = function()
			require("quarto").setup()
			local quarto = require("quarto")

			quarto.setup()

			vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })

			local runner = require("quarto.runner")

			vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "Quarto run cell", silent = true })
			vim.keymap.set(
				"n",
				"<localleader>ra",
				runner.run_above,
				{ desc = "Quarto run cell and above", silent = true }
			)
			vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "Quarto run all cells", silent = true })
			vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "Quarto run line", silent = true })
			vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Quarto run visual range", silent = true })
			vim.keymap.set("n", "<localleader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages", silent = true })
		end,
		lazy = true,
	},

	{ -- directly open ipynb files as quarto docuements
		-- and convert back behind the scenes
		"GCBallesteros/jupytext.nvim",
		opts = {
			custom_language_formatting = {
				python = {
					extension = "qmd",
					style = "quarto",
					force_ft = "quarto",
				},
				r = {
					extension = "qmd",
					style = "quarto",
					force_ft = "quarto",
				},
			},
		},
	},

	{ -- send code from python/r/qmd documets to a terminal or REPL
		-- like ipython, R, bash
		"jpalardy/vim-slime",
		dev = false,
		init = function()
			vim.b["quarto_is_python_chunk"] = false

			Quarto_is_in_python_chunk = function()
				require("otter.tools.functions").is_otter_language_context("python")
			end

			vim.cmd([[
      let g:slime_dispatch_ipython_pause = 100
      function SlimeOverride_EscapeText_quarto(text)
      call v:lua.Quarto_is_in_python_chunk()
      if exists('g:slime_python_ipython') && len(split(a:text,"\n")) > 1 && b:quarto_is_python_chunk && !(exists('b:quarto_is_r_mode') && b:quarto_is_r_mode)
      return ["%cpaste -q\n", g:slime_dispatch_ipython_pause, a:text, "--", "\n"]
      else
      if exists('b:quarto_is_r_mode') && b:quarto_is_r_mode && b:quarto_is_python_chunk
      return [a:text, "\n"]
      else
      return [a:text]
      end
      end
      endfunction
      ]])

			vim.g.slime_target = "neovim"
			vim.g.slime_no_mappings = true
			vim.g.slime_python_ipython = 1
		end,
		config = function()
			vim.g.slime_input_pid = false
			vim.g.slime_suggest_default = true
			vim.g.slime_menu_config = false
			vim.g.slime_neovim_ignore_unlisted = true

			local function mark_terminal()
				local job_id = vim.b.terminal_job_id
				vim.print("job_id: " .. job_id)
			end

			local function set_terminal()
				vim.fn.call("slime#config", {})
			end
			vim.keymap.set("n", "<leader>cm", mark_terminal, { desc = "[m]ark terminal" })
			vim.keymap.set("n", "<leader>cs", set_terminal, { desc = "[s]et terminal" })
		end,
	},

	{
		"benlubas/molten-nvim",
		enabled = false,
		build = ":UpdateRemotePlugins",
		init = function()
			vim.g.molten_image_provider = "image.nvim"
			vim.g.molten_output_win_max_height = 20
			vim.g.molten_auto_open_output = false
		end,
		keys = {
			{ "<leader>mi", ":MoltenInit<cr>", desc = "[m]olten [i]nit" },
			{
				"<leader>mv",
				":<C-u>MoltenEvaluateVisual<cr>",
				mode = "v",
				desc = "molten eval visual",
			},
			{ "<leader>mr", ":MoltenReevaluateCell<cr>", desc = "molten re-eval cell" },
		},
	},

	{ -- terminal
		"akinsho/toggleterm.nvim",
		opts = {
			open_mapping = [[<c-\>]],
			direction = "float",
		},
	},

	{ -- highlight markdown headings and code blocks etc.
		"lukas-reineke/headlines.nvim",
		enabled = false,
		dependencies = "nvim-treesitter/nvim-treesitter",
		config = function()
			require("headlines").setup({
				quarto = {
					query = vim.treesitter.query.parse(
						"markdown",
						[[
                (fenced_code_block) @codeblock
                ]]
					),
					codeblock_highlight = "CodeBlock",
					treesitter_language = "markdown",
				},
				markdown = {
					query = vim.treesitter.query.parse(
						"markdown",
						[[
                (fenced_code_block) @codeblock
                ]]
					),
					codeblock_highlight = "CodeBlock",
				},
			})
		end,
	},
}
