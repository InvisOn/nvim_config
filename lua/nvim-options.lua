vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.autowrite = true
vim.opt.smarttab = false
-- vim.opt.max_line_length = 120

vim.cmd("set number")
vim.opt.relativenumber = true
vim.cmd("highlight LineNr guifg=DarkGrey")

vim.cmd(":set colorcolumn=120")
vim.cmd("hi ColorColumn guibg=#272a3f")

vim.api.nvim_create_autocmd("ExitPre", {
	pattern = "*",
	callback = function(event)
		for _, buf in ipairs(vim.api.nvim_list_bufs()) do
			if vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
				vim.api.nvim_buf_delete(buf, { force = true })
			end
		end
	end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.py", "*.rs", "*.lua", "*.typ", "*.ml", "*.hs" },
	callback = function()
		vim.lsp.buf.format()
	end,
})

vim.cmd([[augroup HelpLineNumber
  autocmd!
  autocmd FileType help setlocal relativenumber
  autocmd FileType man setlocal relativenumber
augroup END]])

vim.api.nvim_create_autocmd("TermOpen", {
	pattern = "*",
	command = "setlocal nospell",
})

vim.opt.swapfile = true

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#CCCCCC" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#CCCCCC" })

vim.cmd([[filetype on]])

vim.filetype.add({
	extension = {
		typ = "typst",
	},
})

vim.opt.fillchars.eob = ""
vim.opt.shell = "bash"

-- To prevert syntax highlighting from flickering when multiple panes with the same file are open
-- https://github.com/neovim/neovim/issues/32660
vim.g._ts_force_sync_parsing = true

vim.diagnostic.config({
	float = {
		border = "rounded",
	},
})

vim.o.winborder = "rounded"
