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

vim.keymap.set("n", "<leader>e", ":make<CR>", { desc = "Make run" })

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

function Search_internet()
  local query = "!firefox 'https://kagi.com/search?q=" .. get_visual_selection() .. "'"

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

vim.api.nvim_set_keymap(
  "n",
  "<leader>co",
  "<CMD>CompilerOpen<CR>",
  { noremap = true, silent = true, desc = "Open compiler" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>c",
  "<CMD>CompilerStop<CR><CMD>CompilerRedo<CR>",
  { noremap = true, silent = true, desc = "Redo last selected option compiler" }
)

vim.api.nvim_set_keymap(
  "n",
  "<leader>ct",
  "<CMD>CompilerToggleResults<CR>",
  { noremap = true, silent = true, desc = "Toggle compiler results" }
)

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
vim.keymap.set("n", "<leader>gs", ":Git<CR>")
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<CR>")
vim.keymap.set("n", "<leader>gc", git_add_current, { desc = "Git add and commit current buffer" })
vim.keymap.set("n", "<leader>gb", toggle_git_blame_line)
vim.keymap.set("n", "<leader>gm", ":Git mergetool<CR>")

-- Improve diff experience
vim.opt.diffopt:append("algorithm:patience")
vim.opt.diffopt:append("indent-heuristic")

vim.keymap.set("n", "<Leader>t", ":TodoTelescope<CR>", { desc = "Telescope TODO" })
vim.api.nvim_set_keymap("i", "<C-t>", " TODO: ", { noremap = true, silent = true, desc = "Insert todo comment" })
vim.api.nvim_set_keymap("n", "<C-t>", "A TODO: ", { noremap = true, silent = true, desc = "Insert todo" })
vim.api.nvim_set_keymap("i", "<C-r>", " NEXT_ACTION: ", { noremap = true, silent = true, desc = "Insert next action" })
vim.api.nvim_set_keymap("n", "<C-r>", "A NEXT_ACTION: ", { noremap = true, silent = true, desc = "Insert next action" })
