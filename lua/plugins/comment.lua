return {
	{
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
		lazy = false,
	},
	{ -- Highlight todo, notes, etc in comments
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
	},
}
