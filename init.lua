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

vim.opt.shortmess:append({ I = true })
require("keymaps") -- needs to be loaded before lazyplugins, otherwise lazyplugins keymaps won't work
require("lazy").setup("plugins")
require("nvim-options")
require("commands")
