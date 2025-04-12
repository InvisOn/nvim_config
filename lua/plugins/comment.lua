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
		opts = {
			signs = false,
			keywords = {
				LEARN = {
					color = "#e0f017",
				},
				NEXT_ACTION = {
					color = "#c84cf3",
					alt = { "NA" },
				},
			},
		},
	},
}
