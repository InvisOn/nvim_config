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
		end,
	},
	{
		"tpope/vim-fugitive",
	},
}
