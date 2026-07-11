return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "mfussenegger/nvim-dap" },
		},
		config = function()
			local builtin = require("telescope.builtin")

			vim.keymap.set(
				"n",
				"<Leader>ff",
				':lua require"telescope.builtin".find_files({ hidden = true })<CR>',
				{ desc = "Telescope find files" }
			)

			vim.keymap.set("n", "<Leader>fw", function()
				builtin.find_files({ hidden = true, default_text = vim.fn.expand("<cword>") })
			end, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<leader>gw", function()
				builtin.live_grep({
					default_text = vim.fn.expand("<cword>"),
				})
			end, { desc = "Find word under cursor with live grep" })

			vim.keymap.set("n", "<Leader>gg", builtin.live_grep, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<Leader><Tab>", function()
				builtin.buffers({ show_all_buffers = false, sort_mru = true })
			end, { desc = "Telescope buffers" })

			vim.keymap.set("n", "<Leader>mm", builtin.keymaps, { desc = "Telescope keymaps" })

			vim.keymap.set("n", "<Leader>yy", builtin.registers, { desc = "Telescope yank history" })

			vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })

			vim.keymap.set("n", "<leader>gs", builtin.git_status, { desc = "Git status" })

			vim.keymap.set("n", "<leader>dd", function()
				builtin.diagnostics({
					layout_strategy = "vertical",
					layout_config = { preview_cutoff = 0, preview_height = 0.7 },
				})
			end, { desc = "Telescope diagnostics" })

			-- vim.keymap.set("n", "gr", builtin.lsp_references, { desc = "Go to references" })

			-- vim.api.nvim_create_autocmd("LspAttach", {
			-- 	callback = function(args)
			-- 		local builtin = require("telescope.builtin")
			-- 		vim.keymap.set("n", "gd", function()
			-- 			builtin.lsp_definitions()
			-- 		end, { buffer = args.buf, desc = "Go to definition" })
			-- 	end,
			-- })

			-- local dap = require("dap")

			-- vim.keymap.set("n", "<leader>dl", dap.list_breakpoints, { desc = "Telescrope list debugger breakpoint" })

			local telescope = require("telescope")

			local wipeout_buf = function(prompt_bufnr)
				local action_state = require("telescope.actions.state")
				local current_picker = action_state.get_current_picker(prompt_bufnr)

				current_picker:delete_selection(function(selection)
					local wins = vim.tbl_filter(function(win)
						return vim.api.nvim_win_get_buf(win) == selection.bufnr
					end, vim.api.nvim_list_wins())

					for _, win in ipairs(wins) do
						-- use enew regardless, safest option
						vim.api.nvim_win_call(win, function()
							vim.cmd("enew")
						end)
					end

					local ok, err = pcall(vim.api.nvim_buf_delete, selection.bufnr, { force = true })
					if not ok then
						vim.notify("failed: " .. tostring(err), vim.log.levels.ERROR)
					end
					return ok
				end)
			end

			telescope.setup({
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
				pickers = {
					buffers = {
						mappings = {
							i = { ["<C-d>"] = wipeout_buf },
							n = { ["<C-d>"] = wipeout_buf },
						},
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
