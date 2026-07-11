return {
	{
		"rmagatti/auto-session",
		dependencies = {
			"nvim-telescope/telescope.nvim",
		},
		config = function()
			require("auto-session").setup({
				suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/", "/tmp" },
				cwd_change_handling = true,
				post_cwd_changed_cmds = {
					function()
						require("lualine").refresh()
					end,
				},
			})

			vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

			vim.keymap.set("n", "<leader>ss", ":Telescope session-lens<CR>", { desc = "Session Lens" })
			vim.keymap.set("n", "<leader>sd", ":AutoSession delete<CR>", { desc = "Delete Session" })
		end,
	},
}
