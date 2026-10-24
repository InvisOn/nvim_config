return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local toggleterm = require("toggleterm")

		toggleterm.setup({
			open_mapping = [[<c-\>]],
			direction = "float",
		})
		vim.keymap.set("n", "<leader>xr", function()
			vim.cmd("w")
			vim.cmd('TermExec cmd="cargo run"')
		end, { desc = "Toggleterm: Save and cargo run" })
		vim.keymap.set("n", "<leader>xt", function()
			vim.cmd("w")
			vim.cmd('TermExec cmd="cargo test"')
		end, { desc = "Toggleterm: Save and cargo test" })
	end,
}
