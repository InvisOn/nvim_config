vim.g.mapleader = " "

-- keybinds
-- " " Copy to clipboard
vim.cmd('noremap  <leader>y  "+y')    -- copy selection
vim.cmd('nnoremap  <leader>Y  "+yg_') -- copy selection
vim.cmd('nnoremap  <leader>y  "+y')   -- copy selection
vim.cmd('nnoremap  <leader>yy  "+yy') -- copy selection

-- " " Paste from clipboard
vim.cmd('nnoremap <leader>p "+p')
vim.cmd('nnoremap <leader>P "+P')
vim.cmd('vnoremap <leader>p "+p')
vim.cmd('vnoremap <leader>P "+P')

vim.api.nvim_create_user_command("Nrc", ":e /home/aj/.config/nvim/init.lua | cd /home/aj/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e /home/aj/.config/fish/config.fish", {})

-- vim.keymap.set("i", "<leader><leader>", "<Esc>") -- close current active buffer
vim.keymap.set("n", "<leader>q", ":bd!<CR>") -- close current active buffer
vim.keymap.set("n", "<leader>d", ":noh<CR>") -- deselect search
-- vim.keymap.set("n", "<leader>t", ":term<CR>") -- deselect search

-- move (selected) lines up or down
vim.cmd("nnoremap <c-k> :m .-2<CR>==")        -- up
vim.cmd("nnoremap <c-j> :m .+1<CR>==")        -- down

vim.cmd("inoremap <c-k> <Esc>:m .-2<CR>==gi") -- up
vim.cmd("inoremap <c-j> <Esc>:m .+1<CR>==gi") -- down

vim.cmd("vnoremap <c-k> :m '<-2<CR>gv=gv")    -- up
vim.cmd("vnoremap <c-j> :m '>+1<CR>gv=gv")    -- down

vim.api.nvim_set_keymap(
    "n",
    "<leader>gx",
    "<CMD>execute '!xdg-open ' .. shellescape(expand('<cfile>'), v:true)<CR><CR>",
    {}
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

    vim.fn.system('xargs -i firefox "https://www.google.com/search?q=$argv{}"', selection)
end

vim.cmd("vnoremap <leader>g :lua Google()<CR>")
