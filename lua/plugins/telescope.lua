return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
		},
		config = function()
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<Leader>ff", function()
				builtin.find_files({ hidden = true })
			end, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<Leader>fw", function()
				builtin.find_files({ hidden = true, default_text = vim.fn.expand("<cword>") })
			end, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<Leader>gg", builtin.live_grep, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<leader>gw", function()
				builtin.live_grep({
					default_text = vim.fn.expand("<cword>"),
				})
			end, { desc = "Find word under cursor with live grep" })

			vim.keymap.set("n", "<Leader><Tab>", function()
				builtin.buffers()
			end, { desc = "Telescope buffers" })

			vim.keymap.set("n", "<Leader>mm", builtin.keymaps, { desc = "Telescope keymaps" })

			vim.keymap.set("n", "<Leader>yy", builtin.registers, { desc = "Telescope yank history" })

			vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })

			vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Go to references" })

			vim.keymap.set("n", "<leader>tr", builtin.resume, { desc = "Resume last telescope session" })

			local telescope = require("telescope")

			telescope.setup({
				pickers = {
					buffers = {
						show_all_buffers = false,
						sort_lastused = true,
						mappings = {
							i = {
								["<c-d>"] = "delete_buffer",
							},
						},
					},
				},
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
				defaults = {
					file_ignore_patterns = {
						"node_modules",
						".git/",
					},
				},
			})

			telescope.load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
		config = function()
			require("telescope").setup({
				extensions = {
					["fzf"] = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
		end,
	},
	{
		"jiaoshijie/undotree",
		dependencies = "nvim-lua/plenary.nvim",
		config = function()
			local undotree = require("undotree")

			undotree.setup({
				float_diff = true, -- using float window previews diff, set this `true` will disable layout option
				layout = "left_bottom", -- "left_bottom", "left_left_bottom"
				position = "left", -- "right", "bottom"
				ignore_filetype = {
					"undotree",
					"undotreeDiff",
					"qf",
					"TelescopePrompt",
					"spectre_panel",
					"tsplayground",
				},
				window = {
					winblend = 0,
				},
				keymaps = {
					["j"] = "move_next",
					["k"] = "move_prev",
					["gj"] = "move2parent",
					["J"] = "move_change_next",
					["K"] = "move_change_prev",
					["<cr>"] = "action_enter",
					["p"] = "enter_diffbuf",
					["q"] = "quit",
				},
			})
		end,
		keys = { -- load the plugin only when using it's keybinding:
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>" },
		},
	},
}
