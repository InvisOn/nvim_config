vim.g.mapleader = " "

-- jump between buffers
vim.api.nvim_set_keymap("n", "<TAB>", ":bnext<CR>", { noremap = true, silent = true, desc = "Next buffer" })
vim.api.nvim_set_keymap("n", "<S-TAB>", ":bprevious<CR>", { noremap = true, silent = true, desc = "Previous buffer" })

-- compiler.nvim
vim.api.nvim_set_keymap("n", "<F6>", "<CMD>CompilerOpen<CR>", { noremap = true, silent = true, desc = "Open compiler" })
vim.api.nvim_set_keymap(
    "n",
    "<F7>",
    "<CMD>CompilerToggleResults<CR>",
    { noremap = true, silent = true, desc = "Toggle compiler pane" }
)
vim.api.nvim_set_keymap("n", "<F8>", "<CMD>CompilerStop<CR>", { noremap = true, silent = true, desc = "Stop compiler" })
vim.api.nvim_set_keymap(
    "n",
    "<F9>",
    "<CMD>CompilerToggleResults<CR><CMD>CompilerStop<CR>",
    { noremap = true, silent = true, desc = "Stop compiler and toggle pane" }
)

vim.api.nvim_create_user_command("Nrc", "cd /home/aj/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e /home/aj/.config/fish/config.fish", {})

vim.api.nvim_set_keymap("n", "<leader>q", ":bd!<CR>", { desc = "Close current active buffer" }) -- close current active buffer
-- vim.keymap.set("n", "<leader>d", ":noh<CR>") -- deselect search
vim.api.nvim_set_keymap("n", "<leader>d", ":noh<CR>", { desc = "Deselect search" })             -- deselect search

-- move (selected) lines up or down
vim.api.nvim_set_keymap("n", "C-k", ":m .-2<CR>==", { noremap = true, silent = true, desc = "Move line up" })          -- move line up
vim.api.nvim_set_keymap("n", "C-j", ":m .+1<CR>==", { noremap = true, silent = true, desc = "Move line down" })        -- move line down

vim.api.nvim_set_keymap("i", "C-k", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true, desc = "Move line up" })   -- move line up
vim.api.nvim_set_keymap("i", "C-j", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true, desc = "Move line down" }) -- move line down

vim.api.nvim_set_keymap("v", "C-k", ":m '<-2<CR>gv=gv", { noremap = true, silent = true, desc = "Move line up" })      -- move line up
vim.api.nvim_set_keymap("v", "C-j", ":m '>+1<CR>gv=gv", { noremap = true, silent = true, desc = "Move line down" })    -- move line down

-- fugitive
vim.api.nvim_set_keymap("n", "<leader>gc", ":Git add --all<CR> <BAR> :Git commit<CR>", { desc = "Git commit" })

vim.api.nvim_set_keymap(
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

vim.api.nvim_set_keymap("v", "<leader>g", ":lua Google()<CR>", { noremap = true, desc = "Google selection" })

vim.api.nvim_set_keymap("v", "<leader>y", '"+y', { noremap = true, desc = "Copy selection to clipboard" })
