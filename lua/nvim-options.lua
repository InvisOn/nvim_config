vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0

-- vim.opt.number = true
vim.cmd("set number")
vim.opt.relativenumber = true
vim.cmd("highlight LineNr guifg=DarkGrey")

-- vim.opt.cursorline = true
vim.cmd(":set colorcolumn=80")
vim.cmd("hi ColorColumn guibg=#272a3f")
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

vim.cmd([[augroup HelpLineNumber
  autocmd!
  autocmd FileType help setlocal relativenumber
  autocmd FileType man setlocal relativenumber
augroup END]])

-- disable swap files
vim.opt.swapfile = true

-- copy to system clipboard with "+y
vim.api.nvim_set_option("clipboard", "unnamed")

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#CCCCCC" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#CCCCCC" })
