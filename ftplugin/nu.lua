vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

local group = vim.api.nvim_create_augroup("NuFormatOnSave", { clear = false })
vim.api.nvim_clear_autocmds({ group = group, buffer = 0 })
vim.api.nvim_create_autocmd("BufWritePre", {
	group = group,
	buffer = 0,
	desc = "Format with nufmt on save",
	callback = function(args)
		vim.lsp.buf.format({
			bufnr = args.buf,
			timeout_ms = 5000,
			filter = function(client)
				return client.name == "null-ls"
			end,
		})
	end,
})
