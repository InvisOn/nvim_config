return {
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		config = function()
			local gitsigns = require("gitsigns")
			local sign_highlights = {
				"GitSignsAdd",
				"GitSignsChange",
				"GitSignsDelete",
				"GitSignsTopdelete",
				"GitSignsChangedelete",
			}
			local default_sign_highlights = {}

			gitsigns.setup()

			for _, highlight in ipairs(sign_highlights) do
				default_sign_highlights[highlight] = vim.api.nvim_get_hl(0, { name = highlight, link = false })
			end

			local function set_commit_sign_highlights()
				for _, highlight in ipairs(sign_highlights) do
					vim.api.nvim_set_hl(0, highlight, { fg = "#8a4175" })
				end
			end

			local function restore_default_sign_highlights()
				for _, highlight in ipairs(sign_highlights) do
					vim.api.nvim_set_hl(0, highlight, default_sign_highlights[highlight])
				end
			end

			local commit_signs_enabled = false
			vim.keymap.set("n", "<leader>gt", function()
				commit_signs_enabled = not commit_signs_enabled
				if commit_signs_enabled then
					set_commit_sign_highlights()
					gitsigns.change_base("main", true)
					return
				end

				gitsigns.change_base(nil, true, restore_default_sign_highlights)
			end, {
				desc = "Toggle Git gutter signs against main",
			})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
}
