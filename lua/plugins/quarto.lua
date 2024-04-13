return {
	{
		"quarto-dev/quarto-nvim",
		config = function()
			require("quarto").setup()
			local quarto = require("quarto")
			quarto.setup()
			vim.keymap.set("n", "<leader>qp", quarto.quartoPreview, { silent = true, noremap = true })
			local runner = require("quarto.runner")
			vim.keymap.set("n", "<localleader>rc", runner.run_cell, { desc = "Quarto run cell", silent = true })
			vim.keymap.set(
				"n",
				"<localleader>ra",
				runner.run_above,
				{ desc = "Quarto run cell and above", silent = true }
			)
			vim.keymap.set("n", "<localleader>rA", runner.run_all, { desc = "Quarto run all cells", silent = true })
			vim.keymap.set("n", "<localleader>rl", runner.run_line, { desc = "Quarto run line", silent = true })
			vim.keymap.set("v", "<localleader>r", runner.run_range, { desc = "Quarto run visual range", silent = true })
			vim.keymap.set("n", "<localleader>RA", function()
				runner.run_all(true)
			end, { desc = "run all cells of all languages", silent = true })
		end,
		lazy = true,
	},
	{
		"jmbuhr/otter.nvim",
		lazy = true,
	},
}
