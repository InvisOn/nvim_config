return {
	"Julian/lean.nvim",
	event = { "BufReadPre *.lean", "BufNewFile *.lean" },
	dependencies = {
		"neovim/nvim-lspconfig",
		"nvim-lua/plenary.nvim",

		-- optional dependencies:

		-- a completion engine
		--    hrsh7th/nvim-cmp or Saghen/blink.cmp are popular choices

		"nvim-telescope/telescope.nvim", -- for 2 Lean-specific pickers
		-- 'andymass/vim-matchup',          -- for enhanced % motion behavior
		-- 'andrewradev/switch.vim',        -- for switch support
		-- 'tomtom/tcomment_vim',           -- for commenting
	},

	---@type lean.Config
	opts = { -- see below for full configuration options
		mappings = true,
		infoview = {
			win_options = {
				winfixbuf = false,
			},
		},
		lsp = {
			on_attach = function()
				vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
			end,
		},
	},
}
