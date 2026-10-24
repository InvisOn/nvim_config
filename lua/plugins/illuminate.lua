return {
	"rrethy/vim-illuminate", -- highlight other uses of the word under the cursor
	lazy = false,
	config = function()
		require("illuminate").configure({
			delay = 100,
			filetypes_denylist = {
				"dirbuf",
				"dirvish",
				"fugitive",
			},
		})
	end,
}
