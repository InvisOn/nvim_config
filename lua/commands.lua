vim.api.nvim_create_user_command("Nrc", "cd ~/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e ~/.config/fish/config.fish", {})

vim.api.nvim_create_user_command("TypstPin", function()
	local client = vim.lsp.get_clients({ name = "tinymist" })[1]
	if not client then
		vim.notify("tinymist not running!", vim.log.levels.ERROR)
		return
	end

	client:request("workspace/executeCommand", {
		command = "tinymist.pinMain",
		arguments = { vim.api.nvim_buf_get_name(0) },
	}, function(err)
		if err then
			vim.notify("error pinning: " .. err.message, vim.log.levels.ERROR)
		else
			vim.notify("successfully pinned", vim.log.levels.INFO)
		end
	end, 0)
end, { desc = "Pin the current file as the Typst main file" })

vim.api.nvim_create_autocmd("FileType", {
	pattern = "lean",
	callback = function()
		vim.bo.commentstring = "--%s"
	end,
})
