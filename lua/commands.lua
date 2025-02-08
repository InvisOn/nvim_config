vim.api.nvim_create_user_command("Nrc", "cd ~/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e ~/.config/fish/config.fish", {})

vim.api.nvim_create_user_command("TypstPin", function()
	local tinymist_id = nil
	for _, client in pairs(vim.lsp.get_active_clients()) do
		if client.name == "tinymist" then
			tinymist_id = client.id
			break
		end
	end

	if not tinymist_id then
		vim.notify("tinymist not running!", vim.log.levels.ERROR)
		return
	end

	local client = vim.lsp.get_client_by_id(tinymist_id)
	if client then
		client.request("workspace/executeCommand", {
			command = "tinymist.pinMain",
			arguments = { vim.api.nvim_buf_get_name(0) },
		}, function(err)
			if err then
				vim.notify("error pinning: " .. err, vim.log.levels.ERROR)
			else
				vim.notify("succesfully pinned", vim.log.levels.INFO)
			end
		end, 0)
	end
end, {})

-- local line1 = "    Old text                    Command         New text\n"
-- local line2 = "============================================================================\n"
-- local line3 = "    surr*ound_words             ysiw)           (surround_words)\n"
-- local line4 = '    *make strings               ys$"            "make strings"\n'
-- local line5 = "    [delete ar*ound me!]        ds]             delete around me!\n"
-- local line6 = "    remove <b>HTML t*ags</b>    dst             remove HTML tags\n"
-- local line7 = "    'change quot*es'            cs'\"            \"change quotes\"\n"
-- local line8 = "    <b>or tag* types</b>        csth1<CR>       <h1>or tag types</h1>\n"
-- local line9 = "    delete(functi*on calls)     dsf             function calls\n"
--
-- vim.api.nvim_create_user_command(
-- 	"Surround",
-- 	vim.bo.printf("%s%s%s%s%s%s%s%s%s", line1, line2, line3, line4, line5, line6, line7, line8, line9),
-- 	{}
-- )
