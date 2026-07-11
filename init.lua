-- bootstrap lazy.vi plugin manager https://github.com/folke/lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- vim.g.rustaceanvim = {
--   server = {
--     cmd = { "lspmux", "client" },
--     default_settings = {
--       ["rust-analyzer"] = {
--         checkOnSave = false,
--       },
--     },
--   },
-- }

local function set_diag_hl()
  local diag_hl = {
    DiagnosticUnderlineError = "#ff0000",
    DiagnosticUnderlineWarn = "#fabd2f",
    DiagnosticUnderlineInfo = "#83a598",
    DiagnosticUnderlineHint = "#8ec07c",
  }
  for group, color in pairs(diag_hl) do
    vim.api.nvim_set_hl(0, group, { undercurl = true, sp = color })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = set_diag_hl,
})

set_diag_hl()

vim.opt.shortmess:append({ I = true })
require("keymaps") -- needs to be loaded before lazyplugins, otherwise lazyplugins keymaps won't work
require("lazy").setup("plugins")
require("nvim-options")
require("commands")
