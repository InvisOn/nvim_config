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

			local function find_base_branch()
				local cwd = vim.fn.expand("%:p:h")
				local candidates = { "origin/HEAD", "main", "master", "develop", "origin/main", "origin/master", "origin/develop" }
				for _, ref in ipairs(candidates) do
					local result = vim.system({ "git", "rev-parse", "--verify", "--quiet", ref .. "^{commit}" }, { cwd = cwd }):wait()
					if result.code == 0 then
						return ref
					end
				end
			end

			local commit_signs_enabled = false
			vim.keymap.set("n", "<leader>gt", function()
				if not commit_signs_enabled then
					local base = find_base_branch()
					if not base then
						vim.notify("No main/master/develop branch found", vim.log.levels.WARN)
						return
					end
					commit_signs_enabled = true
					set_commit_sign_highlights()
					gitsigns.change_base(base, true)
					return
				end
				commit_signs_enabled = false

				gitsigns.change_base(nil, true, restore_default_sign_highlights)
			end, {
				desc = "Toggle Git gutter signs against default branch",
			})
		end,
	},
	{
		"tpope/vim-fugitive",
	},
}
