return {
	"stevearc/conform.nvim",
	config = function()
		require("conform").setup({
			formatters_by_ft = {
				roc = { "roc_fmt" },
				nu = { "nufmt" },
			},
			formatters = {
				nufmt = { command = "nufmt", args = { "--stdin" }, stdin = true },
				roc_fmt = { command = "roc", args = { "fmt", "--stdin" }, stdin = true },
			},
			format_on_save = {
				timeout_ms = 2000,
				lsp_format = "fallback",
			},
		})
	end,
}
