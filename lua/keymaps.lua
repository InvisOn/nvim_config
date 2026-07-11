vim.g.mapleader = " "

vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true, desc = "Go to normal mode from terminal mode" })
vim.api.nvim_set_keymap("n", "<leader>O", "z=", { noremap = true, desc = "Fix typo (extended)" })
vim.api.nvim_set_keymap("n", "<leader>o", "1z=", { noremap = true, desc = "Fix typo" })

-- jump between buffers
vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

vim.keymap.set("n", "<leader>qt", ":bd<CR>", { desc = "Close current active buffer" })
vim.keymap.set("n", "<leader>qi", ":%bd|e#<CR>", { desc = "Close current inactive buffers" })
vim.keymap.set("n", "<leader>qa", ":%bd<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "<leader>d", ":noh<CR>", { desc = "Deselect search" })

local function get_visual_selection()
	local s_start = vim.fn.getpos("'<")
	local s_end = vim.fn.getpos("'>")
	local n_lines = math.abs(s_end[2] - s_start[2]) + 1
	local lines = vim.api.nvim_buf_get_lines(0, s_start[2] - 1, s_end[2], false)
	lines[1] = string.sub(lines[1], s_start[3], -1)
	if n_lines == 1 then
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3] - s_start[3] + 1)
	else
		lines[n_lines] = string.sub(lines[n_lines], 1, s_end[3])
	end
	return table.concat(lines, "\n")
end

function Search_internet()
	local query = '!"C:\\Program Files\\Mozilla Firefox\\firefox.exe" "https://google.com/search?q='
		.. get_visual_selection()
		.. '"'

	vim.cmd(query)
end

vim.keymap.set(
	"v",
	"<leader>g",
	":lua Search_internet()<CR>",
	{ noremap = true, desc = "Search for the selelected text with Kagi" }
)

vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, desc = "Paste clipboard" })
