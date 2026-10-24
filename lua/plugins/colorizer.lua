return {
	{
		"catgoose/nvim-colorizer.lua",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			-- colorizer needs true colors on before setup
			vim.o.termguicolors = true
			require("colorizer").setup()
		end,
	},
}
