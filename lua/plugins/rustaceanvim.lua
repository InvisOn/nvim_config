return {
	{
		"mrcjkb/rustaceanvim",
		-- To avoid being surprised by breaking changes,
		-- I recommend you set a version range
		version = "^9",
		-- This plugin implements proper lazy-loading (see :h lua-plugin-lazy).
		-- No need for lazy.nvim to lazy-load it.
		lazy = false,
		init = function()
			---@type rustaceanvim.Opts
			vim.g.rustaceanvim = {
				server = {
					cmd = { "lspmux", "client" },
					default_settings = {
						["rust-analyzer"] = {
							checkOnSave = false,
						},
					},
				},
			}

			vim.keymap.set("n", "<leader>uc", function()
				vim.cmd.RustLsp({ "flyCheck", "run" })
			end, { desc = "rust: flyCheck run" })
		end,
	},
	{
		"j-hui/fidget.nvim",
		opts = {},
	},
}
