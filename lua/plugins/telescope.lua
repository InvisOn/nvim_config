return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.5",
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Telescope find files" })

			vim.keymap.set("n", "<Leader>lg", builtin.live_grep, { desc = "Telescope live grep" })

			vim.keymap.set("n", "<Leader><Tab>", function()
				builtin.buffers({ show_all_buffers = false, sort_mru = true })
			end, { desc = "Telescope buffers" })

			vim.keymap.set("n", "<Leader>kk", builtin.keymaps, { desc = "Telescope keymaps" })

			vim.keymap.set("n", "<Leader>yy", builtin.registers, { desc = "Telescope keymaps" })

			vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help tags" })
		end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({}),
					},
				},
			})
			require("telescope").load_extension("ui-select")
		end,
	},
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && \
        cmake --build build --config Release && \
        cmake --install build --prefix build",
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true,
						override_generic_sorter = true,
						override_file_sorter = true,
						case_mode = "smart_case",
					},
				},
			})
			require("telescope").load_extension("fzf")
		end,
	},
	{
		"debugloop/telescope-undo.nvim",
		dependencies = { -- note how they're inverted to above example
			{
				"nvim-telescope/telescope.nvim",
				dependencies = { "nvim-lua/plenary.nvim" },
			},
		},
		keys = {
			{ -- lazy style key map
				"<leader>u",
				"<cmd>Telescope undo<cr>",
				desc = "Undo history",
			},
		},
		opts = {
			extensions = {
				undo = {
					use_delta = true,
					use_custom_command = nil, -- setting this implies `use_delta = false`. Accepted format is: { "bash", "-c", "echo '$DIFF' | delta" }
					side_by_side = false,
					vim_diff_opts = {
						ctxlen = vim.o.scrolloff,
					},
					entry_format = "state #$ID, $STAT, $TIME",
					time_format = "",
					saved_only = false,
				},
			},
		},
		config = function(_, opts)
			-- Calling telescope's setup from multiple specs does not hurt, it will happily merge the
			--
			-- configs for us. We won't use data, as everything is in it's own namespace (telescope
			-- defaults, as well as each extension).
			require("telescope").setup(opts)
			i = 8
			bork = 8
			a = 1
			require("telescope").load_extension("undo")
		end,
	},
}
