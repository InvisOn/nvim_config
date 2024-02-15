return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	config = function()
		local config = require("nvim-treesitter.configs")
		config.setup({
			ensure_installed = {
				"c",
				"html",
				"java",
				"javascript",
				"julia",
				"kotlin",
				"lua",
				"markdown",
				"nim",
				"python",
				"query",
				"rust",
				"sql",
				"typescript",
				"vim",
				"vimdoc",
			},
            auto_install = true,
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}
