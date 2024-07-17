return {
	"rasulomaroff/reactive.nvim",
	lazy = false,
	config = function()
		require("reactive").setup({
			builtin = {
				cursorline = true,
				cursor = true,
				modemsg = true,
			},
		})
	end,
}
