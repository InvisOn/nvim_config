vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.showtabline = 0
vim.opt.autowrite = true
-- vim.opt.max_line_length = 120

vim.cmd("set number")
vim.opt.relativenumber = true
vim.cmd("highlight LineNr guifg=DarkGrey")

vim.cmd(":set colorcolumn=120")
vim.cmd("hi ColorColumn guibg=#272a3f")
vim.cmd([[autocmd BufWritePre * lua vim.lsp.buf.format()]])

vim.cmd([[augroup HelpLineNumber
  autocmd!
  autocmd FileType help setlocal relativenumber
  autocmd FileType man setlocal relativenumber
augroup END]])

-- disable swap files
vim.opt.swapfile = true

vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#CCCCCC" })
vim.api.nvim_set_hl(0, "LineNr", { fg = "white" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#CCCCCC" })

-- FIX: when `dune init project MyProjext`, the lsp complains that no context is set for merlin when editing a `.ml` file.
-- FIX: when `dune init project MyProjext`, the lsp complains that the lsp is not set correct version for the compiler.
-- https://github.com/kmicinski/example-ocaml-merlin/blob/master/.merlin
-- https://github.com/ocaml/merlin
-- I can get it to work if I use the vimscript code
-- compiler issues can be solved with https://ocaml.org/docs/install-a-specific-ocaml-compiler-version
-- merlin is just another lsp. ocaml-lsp-server uses merlin under the hood anyway

-- local opamshare = vim.fn.system("opam config var share"):gsub("\n", "")
-- vim.cmd('execute "set rtp+="' .. opamshare .. '"/merlin/vim"')
-- vim.cmd("echo " .. opamshare)
