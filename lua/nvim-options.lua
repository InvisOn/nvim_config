vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.autowrite = true
vim.opt.smarttab = false

vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.colorcolumn = "120"
vim.opt.swapfile = true
vim.opt.fillchars.eob = ""
vim.opt.shell = "bash"
vim.opt.ttimeoutlen = 0
vim.o.winborder = "rounded"
vim.o.exrc = true

vim.opt.diffopt:append("algorithm:patience")
vim.opt.diffopt:append("indent-heuristic")

-- set after the colorscheme loads (see init.lua), so these override it
vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#272a3f" })
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#CCCCCC" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#CCCCCC" })

-- To prevent syntax highlighting from flickering when multiple panes with the same file are open
-- https://github.com/neovim/neovim/issues/32660
vim.g._ts_force_sync_parsing = true

vim.diagnostic.config({
	float = {
		border = "rounded",
	},
})

vim.filetype.add({ extension = { roc = "roc" } })

vim.api.nvim_create_autocmd("ExitPre", {
	callback = function()
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.bo[buf].buftype == "terminal" then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help", "man" },
	command = "setlocal relativenumber",
})

vim.api.nvim_create_autocmd("TermOpen", {
	command = "setlocal nospell",
})
