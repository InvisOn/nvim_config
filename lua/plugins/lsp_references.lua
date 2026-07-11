return {
	"ibhagwan/fzf-lua",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		local fzf = require("fzf-lua")

		fzf.setup({
			winopts = {
				height = 0.85,
				width = 0.80,
				backdrop = false,
				preview = {
					layout = "horizontal",
					horizontal = "right:60%",
				},
			},
			fzf_opts = {
				["--layout"] = "default",
				["--tac"] = "", -- reverse result order so list grows from bottom up
			},

			files = {
				hidden = true,
				file_ignore_patterns = { "node_modules", ".git/" },
			},
			grep = {
				file_ignore_patterns = { "node_modules", ".git/" },
			},
			lsp = {
				async_or_timeout = true, -- open window immediately, stream results
			},
		})

		vim.keymap.set("n", "gr", function()
			fzf.lsp_references({ async_or_timeout = true })
		end, { desc = "LSP References" })

		vim.keymap.set("n", "gd", function()
			fzf.lsp_definitions({ jump1 = true })
		end, { desc = "LSP Definitions", nowait = true })
	end,
}
