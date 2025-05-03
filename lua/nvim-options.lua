vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.autowrite = true
-- vim.opt.max_line_length = 120

vim.opt.spelllang = "en_nz"

vim.cmd("set number")
vim.opt.relativenumber = true
vim.cmd("highlight LineNr guifg=DarkGrey")

vim.cmd(":set colorcolumn=120")
vim.cmd("hi ColorColumn guibg=#272a3f")

vim.api.nvim_create_augroup("AutoFormat", {})
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.py", "*.rs", "*.lua", "*.typ" },
  group = "AutoFormat",
  callback = function()
    vim.cmd("lua vim.lsp.buf.format()")
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

vim.filetype.add({
  extension = {
    typ = "typst",
  },
})

-- vim.diagnostic.config({
-- 	virtual_text = false,
-- })
vim.opt.fillchars.eob = ""
