return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		local toggleterm = require("toggleterm")

		toggleterm.setup({
			open_mapping = [[<c-\>]],
			direction = "float",
		})
		vim.keymap.set("n", "<leader>or", function()
			vim.cmd("w")
			vim.cmd('TermExec cmd="cargo run"')
		end, { desc = "Execute cargo run in terminal" })
		-- vim.keymap.set("n", "<leader>ot", function()
		-- 	vim.cmd("w")
		-- 	vim.cmd('TermExec cmd="cargo test"')
		-- end, { desc = "Cargo test" })
		vim.keymap.set("n", "<leader>ot", function()
			vim.cmd("w")
			vim.cmd('TermExec cmd="cargo test"')
		end, { desc = "Execute cargo test command in terminal" })
	end,
}
