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
		config = function(_, opts)
			require("todo-comments").setup(opts)

			-- Keywords are only highlighted inside comments. In markdown, also
			-- treat any line with a keyword as a comment, so keywords in plain
			-- text get highlighted without the highlight spreading to the lines
			-- below.
			local highlight = require("todo-comments.highlight")
			local is_comment = highlight.is_comment
			highlight.is_comment = function(buf, row, col)
				if is_comment(buf, row, col) then
					return true
				end
				if vim.bo[buf].filetype == "markdown" then
					local line = vim.api.nvim_buf_get_lines(buf, row, row + 1, false)[1] or ""
					return highlight.match(line) ~= nil
				end
				return false
			end
		end,
		opts = {
			signs = false,
			highlight = {
				-- The default of 400 skips long single-line markdown comments
				max_line_len = false,
			},
			keywords = {
				LEARN = {
					color = "#e0f017",
				},
				NEXT_ACTION = {
					color = "#c84cf3",
					alt = { "NA" },
				},
				REVIEW = {
					color = "#f38b4c",
					alt = { "CR" },
				},
				NIT = {
					color = "#4cc9f3",
					alt = { "NITPICK" },
				},
			},
		},
	},
}
