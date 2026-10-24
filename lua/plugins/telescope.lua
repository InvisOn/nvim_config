return {
	{
		"nvim-telescope/telescope.nvim",
		dependencies = {
			{ "nvim-lua/plenary.nvim" },
			{ "nvim-telescope/telescope-ui-select.nvim" },
			{ "nvim-telescope/telescope-fzf-native.nvim" },
		},
		config = function()
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<Leader>ff", function()
				builtin.find_files({ hidden = false })
			end, { desc = "Telescope: Find files" })

			vim.keymap.set("n", "<Leader>fw", function()
				builtin.find_files({ hidden = false, default_text = vim.fn.expand("<cword>") })
			end, { desc = "Telescope: Find files matching word under cursor" })

			vim.keymap.set("n", "<Leader>gg", builtin.live_grep, { desc = "Telescope: Live grep" })

			vim.keymap.set("n", "<leader>gw", function()
				builtin.live_grep({
					default_text = vim.fn.expand("<cword>"),
				})
			end, { desc = "Telescope: Live grep word under cursor" })

			vim.keymap.set("n", "<Leader><Tab>", function()
				builtin.buffers()
			end, { desc = "Telescope: Buffers" })

			vim.keymap.set("n", "<Leader>mm", builtin.keymaps, { desc = "Telescope: Keymaps" })

			vim.keymap.set("n", "<Leader>yy", builtin.registers, { desc = "Telescope: Registers" })

			vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Telescope: Help tags" })

			vim.keymap.set("n", "<leader>gr", builtin.lsp_references, { desc = "Telescope: LSP references" })

			vim.keymap.set("n", "<leader>tr", builtin.resume, { desc = "Telescope: Resume last picker" })

			vim.keymap.set("n", "<leader>dd", function()
				builtin.diagnostics({
					layout_strategy = "vertical",
					layout_config = { preview_cutoff = 0, preview_height = 0.7 },
				})
			end, { desc = "Telescope: Diagnostics" })

			-- Git diff previews rendered by delta. Runs in a terminal so git pipes
			-- through delta as its pager; preview scrolling goes to delta's less.
			local previewers = require("telescope.previewers")
			local function delta_previewer(build_args, delta_flags)
				local pager = "core.pager=delta" .. (delta_flags and (" " .. delta_flags) or "")
				return previewers.new_termopen_previewer({
					get_command = function(entry)
						local file, args = build_args(entry)
						return vim.list_extend({ "git", "-C", vim.fs.dirname(file), "-c", pager }, args)
					end,
				})
			end

			local delta_status = delta_previewer(function(entry)
				if entry.status:match("%?") then
					-- untracked: show the whole file as added
					return entry.path, { "diff", "--no-index", "--", "/dev/null", entry.path }
				end
				-- staged and unstaged changes together
				return entry.path, { "diff", "HEAD", "--", entry.path }
			end, "--line-numbers")

			local delta_bcommits = delta_previewer(function(entry)
				return entry.current_file,
					{ "show", "--format=%h %s%n%an, %ar%n", entry.value, "--", entry.current_file }
			end, "--line-numbers")

			-- file list 25%, diff 75%
			local diff_layout = {
				layout_strategy = "horizontal",
				layout_config = { width = 0.95, height = 0.9, preview_width = 0.75 },
			}

			vim.keymap.set("n", "<leader>gs", function()
				builtin.git_status(vim.tbl_extend("force", diff_layout, { previewer = delta_status }))
			end, { desc = "Telescope: Git status" })

			vim.keymap.set("n", "<leader>gb", function()
				builtin.git_bcommits(vim.tbl_extend("force", diff_layout, { previewer = delta_bcommits }))
			end, { desc = "Telescope: Buffer commits" })

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
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
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
						layout_config = {
							horizontal = {
								width = 0.7,
								height = 0.8,
							},
						},
						show_all_buffers = false,
						sort_lastused = true,
						mappings = {
							i = { ["<C-d>"] = wipeout_buf },
							n = { ["<C-d>"] = wipeout_buf },
						},
					},
				},
			})

			telescope.load_extension("ui-select")
			-- falls back to the default sorter if the native library isn't built yet
			pcall(telescope.load_extension, "fzf")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
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
			{ "<leader>u", "<cmd>lua require('undotree').toggle()<cr>", desc = "Undotree: Toggle" },
		},
	},
}
