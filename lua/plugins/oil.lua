return {
	"stevearc/oil.nvim",
	lazy = false,
	config = function()
		require("oil").setup({
			columns = {},
			win_options = {
				signcolumn = "no",
			},
			view_options = {
				-- Show files and directories that start with "."
				show_hidden = true,
			},
		})
		vim.keymap.set("n", "<leader>b", ":Oil<CR>", { desc = "Open Oilbuffer picker" })
	end,
}
