vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap("t", "<ESC>", "<C-\\><C-n>", { noremap = true, desc = "Go to normal mode from terminal mode" })
vim.api.nvim_set_keymap("n", "<leader>O", "z=", { noremap = true, desc = "Fix typo (extended)" })
vim.api.nvim_set_keymap("n", "<leader>o", "1z=", { noremap = true, desc = "Fix typo" })

-- jump between buffers
vim.keymap.set("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.keymap.set("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

vim.keymap.set("n", "<leader>qt", ":Bdelete<CR>", { desc = "Close current active buffer" })
vim.keymap.set("n", "<leader>qi", ":%bd|e#<CR>", { desc = "Close current inactive buffers" })
vim.keymap.set("n", "<leader>qa", ":%bd<CR>", { desc = "Close all buffers" })
vim.keymap.set("n", "<leader>h", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

vim.keymap.set("n", "<leader>e", ":w<CR>:TermExec cmd='make'<CR>", { desc = "Make run" })

vim.keymap.set(
	"n",
	"<leader>gx",
	"<CMD>execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)<CR><CR>",
	{ desc = "Open file in default program or link browser" }
)

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

local function url_encode(text)
	return (text:gsub("[^%w%-_%.~]", function(c)
		return string.format("%%%02X", string.byte(c))
	end))
end

vim.keymap.set("v", "<leader>/", function()
	-- leave visual mode first so the '< and '> marks point at this selection
	vim.cmd("normal! \27")
	vim.ui.open("https://kagi.com/search?q=" .. url_encode(get_visual_selection()))
end, { desc = "Search for the selected text with Kagi" })

vim.keymap.set("v", "<leader>y", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
vim.keymap.set("n", "<leader>p", '"+p', { noremap = true, desc = "Paste clipboard" })
vim.keymap.set("n", "<leader>yw", '"+yiw', { desc = "Copy word under cursor to system clipboard" })

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
		keys = [[o```<CR><CR>```{]] .. lang .. [[}<esc>o]]
	else
		keys = [[o```{]] .. lang .. [[}<CR>```<esc>O]]
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

vim.keymap.set(
	"v",
	"<leader>wc",
	[[:s/\w\+/&/gn<CR>:noh<CR>]],
	{ noremap = true, silent = true, desc = "Word count selection." }
)

-- fugitive
local function git_add_current()
	vim.cmd("w")
	vim.api.nvim_command("Git add %")
	vim.api.nvim_command("Git commit")
	vim.api.nvim_command("startinsert")
end

vim.g.gitblame_display_virtual_text = 0 -- to disable git blame initially

local function toggle_git_blame_line()
	if vim.g.gitblame_display_virtual_text == 0 then
		vim.g.gitblame_display_virtual_text = 1
	else
		vim.g.gitblame_display_virtual_text = 0
	end
end

-- Fugative keysbind
-- Helpful keymaps for Git operations
-- vim.keymap.set("n", "<leader>gs", ":Git<CR>")
-- vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
-- vim.keymap.set("n", "<leader>gc", git_add_current, { desc = "Git add and commit current buffer" })
-- vim.keymap.set("n", "<leader>gb", toggle_git_blame_line)
-- vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>")

-- Diff of the current file (staged + unstaged vs HEAD), rendered by delta.
-- No pager: output lands in the terminal buffer so the cursor can be placed
-- on the diff line matching the buffer's cursor line. q closes it, Enter
-- jumps to that line in the file.
vim.keymap.set("n", "<leader>gd", function()
	local file = vim.fn.expand("%:p")
	local dir = vim.fn.fnamemodify(file, ":h")
	local line = vim.fn.line(".")
	local src_win = vim.api.nvim_get_current_win()
	local src_buf = vim.api.nvim_get_current_buf()

	-- right column is the new-file line number, right-aligned so it's easy to parse
	local cmd = "git -C "
		.. vim.fn.shellescape(dir)
		.. " diff --color=always HEAD -- "
		.. vim.fn.shellescape(file)
		.. " | delta --paging=never --line-numbers"
		.. " --line-numbers-left-format '{nm:>4}⋮' --line-numbers-right-format '{np:>4}│'"

	-- centered float, same feel as the toggleterm float
	local buf = vim.api.nvim_create_buf(false, true)
	local width = math.floor(vim.o.columns * 0.8)
	local height = math.floor(vim.o.lines * 0.8)
	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		width = width,
		height = height,
		col = math.floor((vim.o.columns - width) / 2),
		row = math.floor((vim.o.lines - height) / 2) - 1,
		title = " " .. vim.fn.fnamemodify(file, ":t") .. " ",
		title_pos = "center",
	})
	vim.keymap.set("n", "q", "<cmd>bwipeout!<CR>", { buffer = buf, nowait = true })
	vim.keymap.set("n", "<Esc>", "<cmd>bwipeout!<CR>", { buffer = buf, nowait = true })

	-- Enter: close the diff and jump to this line in the file. Removed lines
	-- have no new line number, so use the next numbered line (or the previous one).
	vim.keymap.set("n", "<CR>", function()
		local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
		local cur = vim.fn.line(".")
		local target
		for i = cur, #lines do
			target = tonumber(lines[i]:match("⋮%s*(%d+)│"))
			if target then
				break
			end
		end
		for i = cur - 1, 1, -1 do
			if target then
				break
			end
			target = tonumber(lines[i]:match("⋮%s*(%d+)│"))
		end
		vim.cmd("bwipeout!")
		if target and vim.api.nvim_win_is_valid(src_win) then
			vim.api.nvim_set_current_win(src_win)
			target = math.min(target, vim.api.nvim_buf_line_count(src_buf))
			vim.api.nvim_win_set_cursor(src_win, { target, 0 })
			vim.cmd("normal! zz")
		end
	end, { buffer = buf, nowait = true })

	vim.fn.jobstart({ "sh", "-c", cmd }, {
		term = true,
		on_exit = function()
			-- let the terminal finish drawing before reading it
			vim.defer_fn(function()
				if not vim.api.nvim_buf_is_valid(buf) or not vim.api.nvim_win_is_valid(win) then
					return
				end
				local best, best_dist
				for i, text in ipairs(vim.api.nvim_buf_get_lines(buf, 0, -1, false)) do
					local n = tonumber(text:match("⋮%s*(%d+)│"))
					if n then
						local dist = math.abs(n - line)
						if not best_dist or dist < best_dist then
							best, best_dist = i, dist
						end
						if dist == 0 then
							break
						end
					end
				end
				if best then
					vim.api.nvim_win_set_cursor(win, { best, 0 })
					vim.api.nvim_win_call(win, function()
						vim.cmd("normal! zz")
					end)
				end
			end, 50)
		end,
	})
end, { desc = "Git diff current file (delta)" })

-- Improve diff experience
vim.opt.diffopt:append("algorithm:patience")
vim.opt.diffopt:append("indent-heuristic")

-- vim.keymap.set("n", "<leader>j", ":w<CR>:TermExec cmd='zig run %'<CR>", { desc = "Run current Zig file" })
-- vim.keymap.set("n", "<leader>n", function()
-- 	local current = vim.fn.expand("%:t")
-- 	local num = current:match("^(%d+)_")
-- 	if num then
-- 		local next_num = tonumber(num) + 1
-- 		local pattern = string.format("%03d_*", next_num)
-- 		local files = vim.fn.glob(pattern, false, true)
-- 		if #files > 0 then
-- 			vim.cmd("edit " .. files[1])
-- 		else
-- 			print("No next file found")
-- 		end
-- 	end
-- end, { desc = "Open next numbered file" })
-- vim.keymap.set("n", "<leader>,", function()
-- 	local current = vim.fn.expand("%:t")
-- 	local num = current:match("^(%d+)_")
-- 	if num then
-- 		local prev_num = tonumber(num) - 1
-- 		local pattern = string.format("%03d_*", prev_num)
-- 		local files = vim.fn.glob(pattern, false, true)
-- 		if #files > 0 then
-- 			vim.cmd("edit " .. files[1])
-- 		end
-- 	end
-- end, { desc = "Open previous numbered file" })

vim.keymap.set("n", "<Leader>td", ":TodoTelescope<CR>", { desc = "Telescope TODO" })

vim.api.nvim_set_keymap("i", "<C-t>", " TODO: ", { noremap = true, silent = true, desc = "Insert todo comment" })
vim.api.nvim_set_keymap("n", "<C-t>", "A TODO: ", { noremap = true, silent = true, desc = "Insert todo" })

vim.api.nvim_set_keymap("i", "<C-f>", " NEXT_ACTION: ", { noremap = true, silent = true, desc = "Insert next action" })
vim.api.nvim_set_keymap("n", "<C-f>", "A NEXT_ACTION: ", { noremap = true, silent = true, desc = "Insert next action" })

vim.api.nvim_set_keymap("i", "<C-l>", " LEARN: ", { noremap = true, silent = true, desc = "Insert learn" })
vim.api.nvim_set_keymap("n", "<C-l>", "A LEARN: ", { noremap = true, silent = true, desc = "Insert learn" })

vim.keymap.set("n", "<leader>ll", function()
	local current = vim.diagnostic.config().virtual_lines
	vim.diagnostic.config({ virtual_lines = not current })
end, { desc = "Toggle diagnostic virtual lines" })
