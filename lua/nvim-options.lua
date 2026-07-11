vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.autowrite = true
vim.opt.textwidth = 120
vim.opt.number = true
vim.opt.relativenumber = true

vim.opt.spelllang = "en_nz"

vim.cmd("set number")
vim.cmd("highlight LineNr guifg=DarkGrey")

vim.cmd(":set colorcolumn=120")
vim.cmd("hi ColorColumn guibg=#272a3f")

vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = { "*.py", "*.lua", "*.rs" },
	group = "AutoFormat",
	callback = function()
		vim.cmd("lua vim.lsp.buf.format({timeout_ms = 5000})")
	end,
})

vim.cmd([[augroup HelpLineNumber
  autocmd!
  autocmd FileType help setlocal relativenumber
  autocmd FileType man setlocal relativenumber
augroup END]])

vim.opt.swapfile = true

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#CCCCCC" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#CCCCCC" })

vim.cmd([[filetype on]])

vim.opt.fillchars.eob = ""
