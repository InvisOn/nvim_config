return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			formatters_by_ft = { lean = { "lean_fmt" } },
			formatters = {
				lean_fmt = { command = "lean-fmt", stdin = true },
			},
		})
	end,
}
