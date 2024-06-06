vim.g.mapleader = " "

-- jump between buffers
vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

-- compiler.nvim
vim.keymap.set("n", "<F6>", "<CMD>CompilerOpen<CR>", { noremap = true, silent = true, desc = "Open compiler" })
vim.keymap.set(
	"n",
	"<F7>",
	"<CMD>CompilerToggleResults<CR>",
	{ noremap = true, silent = true, desc = "Toggle compiler pane" }
)

vim.keymap.set("n", "<F8>", "<CMD>CompilerStop<CR>", { noremap = true, silent = true, desc = "Stop compiler" })
vim.keymap.set(
	"n",
	"<F9>",
	"<CMD>CompilerToggleResults<CR><CMD>CompilerStop<CR>",
	{ noremap = true, silent = true, desc = "Stop compiler and toggle pane" }
)

vim.api.nvim_create_user_command("Nrc", "cd /home/aj/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e /home/aj/.config/fish/config.fish", {})

vim.keymap.set("n", "<leader>q", ":bd!<CR>", { desc = "Close current active buffer" }) -- close current active buffer
vim.keymap.set("n", "<leader>d", ":noh<CR>", { desc = "Deselect search" }) -- deselect search
vim.keymap.set("n", "<leader>d", ":noh<CR>", { desc = "Deselect search" }) -- deselect search

-- fugitive
vim.keymap.set("n", "<leader>gc", ":Git add --all<CR> <BAR> :Git commit<CR>", { desc = "Git commit" })

vim.keymap.set(
	"n",
	"<leader>gx",
	"<CMD>execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)<CR><CR>",
	{ desc = "Open file in default program or link browser" }
)

function Google()
	-- get visual selection and google it
	local start_pos = vim.api.nvim_buf_get_mark(0, "<")
	local end_pos = vim.api.nvim_buf_get_mark(0, ">")
	local lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)

	if #lines == 0 then
		return
	end

	local selection = ""
	if #lines == 1 then
		selection = string.sub(lines[1], start_pos[2] + 1, end_pos[2] + 1)
	else
		selection = string.sub(lines[1], start_pos[2] + 1)
		for i = 2, #lines - 1 do
			selection = selection .. " " .. lines[i]
		end
		selection = selection .. " " .. string.sub(lines[#lines], 1, end_pos[2] + 1)
	end

	vim.cmd(":echo '" .. selection .. "'")
	vim.fn.system("xargs -i firefox 'https://www.google.com/search?q={}'", selection)
end

vim.keymap.set("v", "<leader>g", ":lua Google()<CR>", { noremap = true, desc = "Google selection" })

vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
