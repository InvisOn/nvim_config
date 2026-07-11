vim.api.nvim_create_user_command("Config", function()
  vim.cmd("cd ~/AppData/Local/nvim")
end, {})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "rust",
  callback = function()
    vim.opt_local.number = true
    vim.opt_local.relativenumber = true
  end,
})
