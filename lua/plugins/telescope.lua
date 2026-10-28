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

			-- wraps a picker so it opens with its previous search already typed in
			local function remember_prompt(picker_fn)
				local last = ""
				return function(opts)
					opts = opts or {}
					opts.default_text = opts.default_text or last
					opts.attach_mappings = function(prompt_bufnr)
						local prefix = require("telescope.actions.state").get_current_picker(prompt_bufnr).prompt_prefix
						-- save when the picker closes, which wipes the prompt buffer
						vim.api.nvim_create_autocmd("BufWipeout", {
							buffer = prompt_bufnr,
							once = true,
							callback = function()
								local line = vim.api.nvim_buf_get_lines(prompt_bufnr, 0, 1, false)[1] or ""
								last = line:sub(#prefix + 1)
							end,
						})
						return true
					end
					picker_fn(opts)
				end
			end

			local live_grep = remember_prompt(builtin.live_grep)

			vim.keymap.set("n", "<Leader>ff", function()
				builtin.find_files({ hidden = false })
			end, { desc = "Telescope: Find files" })

			vim.keymap.set("n", "<Leader>fw", function()
				builtin.find_files({ hidden = false, default_text = vim.fn.expand("<cword>") })
			end, { desc = "Telescope: Find files matching word under cursor" })

			vim.keymap.set("n", "<Leader>gg", live_grep, { desc = "Telescope: Live grep" })

			vim.keymap.set("n", "<leader>gw", function()
				live_grep({
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

			vim.keymap.set(
				"n",
				"<leader>gO",
				builtin.lsp_document_symbols,
				{ desc = "Telescope: LSP document symbols" }
			)

			vim.keymap.set("n", "<leader>dd", function()
				builtin.diagnostics({
					layout_strategy = "vertical",
					layout_config = { preview_cutoff = 0, preview_height = 0.7 },
				})
			end, { desc = "Telescope: Diagnostics" })

			-- Git diff previews rendered by delta. Runs in a terminal so git pipes
			-- through delta as its pager; delta paging is off so <C-d>/<C-u> scroll the preview.
			local previewers = require("telescope.previewers")
			local delta_flags = "--line-numbers --paging=never"
			local function delta_command(file, args)
				return vim.list_extend(
					{ "git", "-C", vim.fs.dirname(file), "-c", "core.pager=delta " .. delta_flags },
					args
				)
			end

			local function status_args(entry)
				if entry.status:match("%?") then
					-- untracked: show the whole file as added
					return entry.path, { "diff", "--no-index", "--", "/dev/null", entry.path }
				end
				-- staged and unstaged changes together
				return entry.path, { "diff", "HEAD", "--", entry.path }
			end

			local function bcommits_args(entry)
				return entry.current_file,
					{ "show", "--format=%h %s%n%an, %ar%n", entry.value, "--", entry.current_file }
			end

			local function delta_previewer(build_args)
				return previewers.new_termopen_previewer({
					get_command = function(entry)
						return delta_command(build_args(entry))
					end,
				})
			end

			local delta_status = delta_previewer(status_args)
			local delta_bcommits = delta_previewer(bcommits_args)

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

			-- Current buffer's diff vs HEAD in one float, rendered by delta. <CR> jumps to the line under the cursor
			-- (delta prints "old│new│" line numbers, so the new-file line is read back from the text); q/<Esc> closes.
			vim.keymap.set("n", "<leader>gd", function()
				local file = vim.api.nvim_buf_get_name(0)
				local source_win = vim.api.nvim_get_current_win()
				local width, height = math.floor(vim.o.columns * 0.9), math.floor(vim.o.lines * 0.85)
				local float_buf = vim.api.nvim_create_buf(false, true)
				local float_win = vim.api.nvim_open_win(float_buf, true, {
					relative = "editor",
					width = width,
					height = height,
					col = math.floor((vim.o.columns - width) / 2),
					row = math.floor((vim.o.lines - height) / 2 - 1),
					style = "minimal",
					border = "rounded",
					title = " Buffer diff  <CR> jump · q close ",
				})
				vim.fn.termopen({
					"git",
					"-C",
					vim.fs.dirname(file),
					"-c",
					"core.pager=delta --paging=never --line-numbers --line-numbers-left-format='{nm:>4}│'"
						.. " --line-numbers-right-format='{np:>4}│'",
					"diff",
					"HEAD",
					"--",
					file,
				})

				local function close()
					if vim.api.nvim_win_is_valid(float_win) then
						vim.api.nvim_win_close(float_win, true)
					end
				end
				vim.keymap.set("n", "q", close, { buffer = float_buf, nowait = true })
				vim.keymap.set("n", "<Esc>", close, { buffer = float_buf, nowait = true })
				vim.keymap.set("n", "<CR>", function()
					local row = vim.api.nvim_win_get_cursor(0)[1]
					local lines = vim.api.nvim_buf_get_lines(float_buf, 0, -1, false)
					-- removed lines have no new number: use the next line that has one, then the previous
					for _, index in ipairs(vim.list_extend(vim.fn.range(row, #lines), vim.fn.range(row - 1, 1, -1))) do
						local lnum = lines[index]:match("^%s*%d*%s*│%s*(%d+)│")
						if lnum then
							close()
							vim.api.nvim_set_current_win(source_win)
							vim.api.nvim_win_set_cursor(source_win, { tonumber(lnum), 0 })
							vim.cmd("normal! zz")
							return
						end
					end
				end, { buffer = float_buf, nowait = true })
				vim.cmd("stopinsert")
			end, { desc = "Buffer diff in a float (enter jumps to line)" })

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
					path_display = function(opts, path)
						return (path:gsub("/", "\\"))
					end,
					-- bigger window, preview takes most of it
					layout_config = {
						horizontal = { width = 0.95, height = 0.9, preview_width = 0.65 },
						vertical = { width = 0.95, height = 0.95, preview_height = 0.6 },
					},
					file_ignore_patterns = {
						"node_modules",
						"%.git/",
					},
				},
				pickers = {
					live_grep = {
						on_input_filter_cb = function(prompt)
							return { prompt = prompt }
						end,
					},
					grep_string = {
						on_input_filter_cb = function(prompt)
							return { prompt = prompt }
						end,
					},
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

			-- accept both slash styles (and markdown-escaped `\_`) in the prompt: prompt and ordinals are matched with "/"
			local function slashes(text)
				return (text:gsub("\\_", "_"):gsub("\\", "/"))
			end
			local pickers = require("telescope.pickers")
			local new_picker = pickers.new
			pickers.new = function(opts, picker_opts, ...)
				opts = opts or {}
				opts.on_input_filter_cb = opts.on_input_filter_cb
					or function(prompt)
						return { prompt = slashes(prompt) }
					end
				local sorter = picker_opts and picker_opts.sorter
				if sorter and not sorter._slashes then
					local score, highlight = sorter.scoring_function, sorter.highlighter
					sorter._slashes = true
					sorter.scoring_function = function(self, prompt, line, ...)
						return score(self, prompt, (line:gsub("\\", "/")), ...)
					end
					if highlight then
						sorter.highlighter = function(self, prompt, display)
							return highlight(self, prompt, (display:gsub("\\", "/")))
						end
					end
				end
				return new_picker(opts, picker_opts, ...)
			end
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
