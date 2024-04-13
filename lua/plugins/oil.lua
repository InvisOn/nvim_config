return {
	"stevearc/oil.nvim",
	config = function()
		require("oil").setup()
		vim.keymap.set("n", "<leader>b", ":Oil<CR>", { desc = "Open Oilbuffer picker" })
	end,
}
