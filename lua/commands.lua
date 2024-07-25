vim.api.nvim_create_user_command("Nrc", "cd ~/.config/nvim/", {})
vim.api.nvim_create_user_command("Frc", ":e ~/.config/fish/config.fish", {})

vim.api.nvim_create_user_command("ExitPre", function()
    vim.cmd("qa")
end, {})

-- https://old.reddit.com/r/neovim/comments/zhweuc/whats_a_fast_way_to_load_the_output_of_a_command/
-- vim.api.nvim_create_user_command("Redir", function(ctx)
--     local lines = vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
--     -- vim.api.nvim_create_buf(false, true)
--     vim.cmd("new")
--     vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
--     -- vim.api.nvim_buf_set_option(buffer_number, "modified", false)
--     vim.opt_local.modified = false
-- end, { nargs = "+", complete = "command" })

-- vim.api.nvim_create_user_command("Make", function()
-- 	local make_out = vim.api.nvim_cmd({ cmd = "make" }, { output = true })
--
-- 	local make_out_sanitized = vim.split(make_out, "\n+")
--
-- 	local buf = vim.api.nvim_create_buf(true, true)
--
-- 	vim.api.nvim_set_option_value("modfiable", false, { buf = buf })
--
-- 	vim.api.nvim_buf_set_lines(buf, -1, -1, true, make_out_sanitized)
--
-- TODO:
-- 1 show buffer
-- 2 vsplit
-- 3 resize

-- Get the window the buffer is in and set the cursor position to the bottom.
-- local buffer_window = vim.api.nvim_call_function("bufwinid", { buffer_number })
-- local buffer_line_count = vim.api.nvim_buf_line_count(buffer_number)
-- vim.api.nvim_win_set_cursor(buffer_window, { buffer_line_count, 0 })
--
-- https://stackoverflow.com/questions/75141843/create-a-temporary-readonly-buffer-for-test-output
-- local function open_buffer()
--     -- Get a boolean that tells us if the buffer number is visible anymore.
--     --
--     -- :help bufwinnr
--     local buffer_visible = vim.api.nvim_call_function("bufwinnr", { buffer_number }) ~= -1
--
--     if buffer_number == -1 or not buffer_visible then
--         -- Create a new buffer with the name "AUTOTEST_OUTPUT".
--         -- Same name will reuse the current buffer.
--         vim.api.nvim_command("botright vsplit AUTOTEST_OUTPUT")
--
--         -- Collect the buffer's number.
--         buffer_number = vim.api.nvim_get_current_buf()
--
--         -- Mark the buffer as readonly.
--         vim.opt_local.readonly = true
--     end
-- end
--
-- function autotest(pattern, command)
--     vim.api.nvim_create_autocmd("BufWritePost", {
--         pattern = pattern,
--         callback = function()
--             -- Open our buffer, if we need to.
--             open_buffer()
--
--             -- Clear the buffer's contents incase it has been used.
--             vim.api.nvim_buf_set_lines(buffer_number, 0, -1, true, {})
--
--             -- Run the command.
--             vim.fn.jobstart(command, {
--                 stdout_buffered = true,
--                 on_stdout = log,
--                 on_stderr = log,
--             })
--         end,
--     })
-- end
-- end, {})
