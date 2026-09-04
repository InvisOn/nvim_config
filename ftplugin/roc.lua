vim.b.did_indent = 1

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt_local.cindent = false
vim.opt_local.smartindent = false
vim.opt_local.autoindent = true
vim.opt_local.indentexpr = ""

-- after/ftplugin/roc.lua
vim.opt.softtabstop = 4
vim.b.did_indent = 1
vim.opt_local.indentexpr = ""
vim.opt_local.cindent = false
vim.opt_local.smartindent = false
vim.opt_local.autoindent = true
vim.opt_local.shiftwidth = 4
vim.opt_local.expandtab = true

-- Override anything the session restores afterwards
local buf = vim.api.nvim_get_current_buf()
vim.api.nvim_create_autocmd({ "BufEnter", "BufWinEnter" }, {
	buffer = buf,
	once = true,
	callback = function()
		vim.bo[buf].indentexpr = ""
		vim.opt_local.autoindent = true
	end,
})
