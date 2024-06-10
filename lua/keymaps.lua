vim.g.mapleader = " "

-- jump between buffers
vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

vim.api.nvim_create_user_command("Nrc", "cd /home/aj/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e /home/aj/.config/fish/config.fish", {})

vim.keymap.set("n", "<leader>q", ":bd!<CR>", { desc = "Close current active buffer" }) -- close current active buffer
vim.keymap.set("n", "<leader>d", ":noh<CR>", { desc = "Deselect search" }) -- deselect search
vim.keymap.set("n", "<leader>d", ":noh<CR>", { desc = "Deselect search" }) -- deselect search

local function git_add_current()
	vim.api.nvim_command("Git add %")
	vim.api.nvim_command("Git commit")
	vim.api.nvim_command("startinsert")
end

-- fugitive
vim.keymap.set("n", "<leader>gc", git_add_current, { desc = "Git commit" })

vim.keymap.set(
	"n",
	"<leader>gx",
	"<CMD>execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)<CR><CR>",
	{ desc = "Open file in default program or link browser" }
)

function Search_internet()
	-- get visual selection and search it on the internet
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
	vim.fn.system("xargs -i firefox 'https://kagi.com/search?q='{}", selection)
end

vim.keymap.set(
	"v",
	"<leader>g",
	":lua Search_internet()<CR>",
	{ noremap = true, desc = "Search for the selelected text with Kagi" }
)

vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
-- vim.keymap.set("n", "<leader>P", '"+p', { noremap = true, desc = "Past clipboard" })

local is_code_chunk = function()
	local current, _ = require("otter.keeper").get_current_language_context()
	if current then
		return true
	else
		return false
	end
end

--- Insert code chunk of given language
--- Splits current chunk if already within a chunk
--- @param lang string
local insert_code_chunk = function(lang)
	vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<esc>", true, false, true), "n", true)

	local keys

	if is_code_chunk() then
		keys = [[o```<cr><cr>```{]] .. lang .. [[}<esc>o]]
	else
		keys = [[o```{]] .. lang .. [[}<cr>```<esc>O]]
	end

	keys = vim.api.nvim_replace_termcodes(keys, true, false, true)

	vim.api.nvim_feedkeys(keys, "n", false)
end

local insert_r_chunk = function()
	insert_code_chunk("r")
end

local insert_py_chunk = function()
	insert_code_chunk("python")
end

local insert_julia_chunk = function()
	insert_code_chunk("julia")
end

vim.keymap.set("n", "<leader>ir", insert_r_chunk, { desc = "Insert R code chunk" })
vim.keymap.set("n", "<leader>ip", insert_py_chunk, { desc = "Insert Python code chunk" })
vim.keymap.set("n", "<leader>ij", insert_julia_chunk, { desc = "Insert Julia code chunk" })
