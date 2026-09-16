return {
	{
		"lewis6991/gitsigns.nvim",
		lazy = false,
		config = function()
			local function pick_base()
				for _, ref in ipairs({ "main", "master" }) do
					if vim.fn.system({ "git", "rev-parse", "--verify", "--quiet", ref }) ~= "" then
						return ref
					end
				end
				return nil -- falls back to gitsigns default (index)
			end

			require("gitsigns").setup({ base = pick_base() })

			local function set_colors()
				for _, group in ipairs({ "GitSignsAdd", "GitSignsChange", "GitSignsDelete" }) do
					vim.api.nvim_set_hl(0, group, { fg = "#8a4175" })
				end
			end

			set_colors()
			vim.api.nvim_create_autocmd("ColorScheme", { callback = set_colors })
		end,
	},
	{
		"tpope/vim-fugitive",
	},
}
