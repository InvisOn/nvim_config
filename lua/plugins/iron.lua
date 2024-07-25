return {
	"Vigemus/iron.nvim",
	lazy = false,
	config = function()
		local iron = require("iron.core")

		iron.setup({
			config = {
				close_window_on_exit = true,
				-- Whether a repl should be discarded or not
				scratch_repl = true,
				-- Your repl definitions come here
				repl_definition = {
					python = require("iron.fts.python").ipython,
					ocaml = {
						command = { "utop" },
					},
					sh = {
						-- Can be a table or a function that
						-- returns a table (see below)
						command = { "fish" },
					},
				},
				-- How the repl window will be displayed
				-- See below for more information
				-- repl_open_cmd = require("iron.view").bottom(0.30),
				repl_open_cmd = "belowright 15 split",
			},
			-- Iron doesn't set keymaps by default anymore.
			-- You can set them here or manually add keymaps to the functions in iron.core
			keymaps = {
				send_motion = "<space>sc",
				visual_send = "<space>sc",
				send_file = "<space>sf",
				send_line = "<space>sl",
				send_until_cursor = "<space>su",
				send_mark = "<space>sm",
				mark_motion = "<space>mc",
				mark_visual = "<space>mc",
				remove_mark = "<space>md",
				cr = "<space>s<CR>",
				interrupt = "<space>s<space>",
				exit = "<space>sq",
				clear = "<space>cl",
			},
			-- If the highlight is on, you can change how it looks
			-- For the available options, check nvim_set_hl
			-- highlight = false,
			-- highlight = {
			-- 	italic = true,
			-- },
			ignore_blank_lines = false, -- ignore blank lines when sending visual select lines
		})

		-- iron also has a list of commands, see :h iron-commands for all available commands
		vim.keymap.set("n", "<space>rs", "<cmd>IronRepl<CR>", { desc = "Open REPL" })
		vim.keymap.set("n", "<space>rrs", "<cmd>IronRestart<CR>", { desc = "Restart REPL" })
		vim.keymap.set("n", "<space>rf", "<cmd>IronFocus<CR>", { desc = "Focus REPL" })
		vim.keymap.set("n", "<space>rh", "<cmd>IronHide<CR>", { desc = "Hide REPL" })
	end,
}
