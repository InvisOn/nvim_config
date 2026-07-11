return {
	{
		"numToStr/Comment.nvim",
		lazy = false,
		config = function()
			-- require("Comment").setup()
			require("Comment").setup({
				pre_hook = function(ctx)
					local ok, tsc = pcall(require, "ts_context_commentstring.integrations.comment_nvim")
					if ok then
						local cs = tsc.create_pre_hook()(ctx)
						if cs then
							return cs
						end
					end
					return vim.bo.commentstring
				end,
			})
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
