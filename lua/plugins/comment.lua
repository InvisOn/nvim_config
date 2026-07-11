return {
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			require("Comment").setup()
		end,
	},
	{
		"folke/todo-comments.nvim",
		dependencies = { "nvim-lua/plenary.nvim" },
		lazy = false,
		keys = {
			{ "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Find all TODOs" },
		},
		opts = {
			signs = false,
			keywords = {
				AJ_TODO = { icon = " ", color = "info" },
			},
		},
	},
}
