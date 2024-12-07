return {
	"nat-418/boole.nvim",
	lazy = false,
	config = function()
		require("boole").setup({
			mappings = {
				increment = "<C-a>",
				decrement = "<C-x>",
			},
			additions = {
				{ "yes", "no" },
			},
		})
	end,
}
