return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local toggleterm = require("toggleterm")

		toggleterm.setup({
			open_mapping = [[<c-\>]],
			direction = "float",
		})
		vim.keymap.set("n", "<leader>cr", function()
			vim.cmd("w")
			vim.cmd('TermExec cmd="cargo run"')
		end, { desc = "Execute cargo run in terminal" })
		vim.keymap.set("n", "<leader>e", function()
			vim.cmd("w")
			vim.cmd('TermExec cmd="make"')
		end, { desc = "Execute make command in terminal" })
	end,
}
