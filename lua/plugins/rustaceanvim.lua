return {
	{
		"mrcjkb/rustaceanvim",
		-- to avoid being surprised by breaking changes,
		-- i recommend you set a version range
		version = "^9",
		-- this plugin implements proper lazy-loading (see :h lua-plugin-lazy).
		-- no need for lazy.nvim to lazy-load it.
		lazy = false,
		init = function()
			---@type rustaceanvim.opts
			vim.g.rustaceanvim = {
				server = {
					cmd = { "lspmux", "client" },
					default_settings = {
						["rust-analyzer"] = {
							checkonsave = false,
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
